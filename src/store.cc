#include "threadpool.h"

#include <iostream>
#include <thread>
#include <grpc++/grpc++.h>
#include "store.grpc.pb.h"
#include "vendor.grpc.pb.h"

using grpc::Server;
using grpc::ServerAsyncResponseWriter;
using grpc::ServerBuilder;
using grpc::ServerCompletionQueue;
using grpc::ServerContext;
using grpc::Status;
using grpc::ClientAsyncResponseReader;
using grpc::ClientContext;
using grpc::Channel;
using grpc::CompletionQueue;

// not sure if we need these
using vendor::BidQuery;
using vendor::BidReply;
using vendor::Vendor;
using store::ProductQuery;
using store::ProductReply;
using store::ProductInfo;
using store::Store;

using namespace std;

class StoreImpl final : public Store::AsyncService{ 
	public:
	~StoreImpl() {
		server_->Shutdown();
		// Always shutdown the completion queue after the server.
		cq_->Shutdown();
	}
	
	void Run() {
    std::string server_address("0.0.0.0:50051");

    ServerBuilder builder;
    // Listen on the given address without any authentication mechanism.
    builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
    // Register "service_" as the instance through which we'll communicate with
    // clients. In this case it corresponds to an *asynchronous* service.
    builder.RegisterService(&service_);
    // Get hold of the completion queue used for the asynchronous communication
    // with the gRPC runtime.
    cq_ = builder.AddCompletionQueue();
    // Finally assemble the server.
    server_ = builder.BuildAndStart();
    std::cout << "Server listening on " << server_address << std::endl;

    // Proceed to the server's main loop.
    HandleRpcs();
  }

  private:
  // Class encompasing the state and logic needed to serve a request.
  class CallData {
   public:
    // Take in the "service" instance (in this case representing an asynchronous
    // server) and the completion queue "cq" used for asynchronous communication
    // with the gRPC runtime.
    CallData(Store::AsyncService* service, ServerCompletionQueue* cq)
        : service_(service), cq_(cq), responder_(&ctx_), status_(CREATE)  {
      // Invoke the serving logic right away.
      std::shared_ptr<Channel> channel = grpc::CreateChannel("localhost:50051", grpc::InsecureChannelCredentials());
      stub_ = Vendor::NewStub(channel);
      Proceed();
    }

    void Proceed() {
      if (status_ == CREATE) {
        // Make this instance progress to the PROCESS state.
        status_ = PROCESS;

        // As part of the initial CREATE state, we *request* that the system
        // start processing SayHello requests. In this request, "this" acts are
        // the tag uniquely identifying the request (so that different CallData
        // instances can serve different requests concurrently), in this case
        // the memory address of this CallData instance.
        service_->RequestgetProducts(&ctx_, &request_, &responder_, cq_, cq_,
                                  this);
      } else if (status_ == PROCESS) {
        // Spawn a new CallData instance to serve new clients while we process
        // the one for this CallData. The instance will deallocate itself as
        // part of its FINISH state.
        new CallData(service_, cq_);

        // The actual processing.
        
        string product_name = request_.product_name();
        vendor::BidQuery bidQueryRequest; 
        bidQueryRequest.set_product_name(product_name);
        std::thread thread_ = std::thread(&CallData::AsyncCompleteRpc, this);
        AsyncClientCall* call = new AsyncClientCall;
        call->response_reader = stub_->PrepareAsyncgetProductBid(&call->context, bidQueryRequest, ccq_);

        // StartCall initiates the RPC call
        call->response_reader->StartCall();

        // Request that, upon completion of the RPC, "reply" be updated with the
        // server's response; "status" with the indication of whether the operation
        // was successful. Tag the request with the memory address of the call
        // object.
        call->response_reader->Finish(&call->bidReply, &call->status, (void*)call);

        // And we are done! Let the gRPC runtime know we've finished, using the
        // memory address of this instance as the uniquely identifying tag for
        // the event.
        status_ = FINISH;
		//store::ProductReply productReply;
		store::ProductInfo* productInfo = reply_.add_products();
		productInfo->set_price(1.0);
		productInfo->set_vendor_id("1");
		
		cout<<"here"<<endl;
        responder_.Finish(reply_, Status::OK, this);
      } else {
        GPR_ASSERT(status_ == FINISH);
        // Once in the FINISH state, deallocate ourselves (CallData).
        delete this;
      }
    }

    void AsyncCompleteRpc() {
      void* got_tag;
      bool ok = false;

      // Block until the next result is available in the completion queue "cq".
      while (ccq_->Next(&got_tag, &ok)) {
        // The tag in this example is the memory location of the call object
        AsyncClientCall* call = static_cast<AsyncClientCall*>(got_tag);

        // Verify that the request was completed successfully. Note that "ok"
        // corresponds solely to the request for updates introduced by Finish().
        GPR_ASSERT(ok);

        if (call->status.ok())
          cout<<" Got reply back from vendor "<<call->bidReply.price()<<endl;

        // Once we're complete, deallocate the call object.
        delete call;
      }
    }

   private:
    // The means of communication with the gRPC runtime for an asynchronous
    // server.
    struct AsyncClientCall{
      BidReply bidReply;
      Status status;
      unique_ptr<ClientAsyncResponseReader<BidReply>> response_reader;
      ClientContext context;
    };

    std::unique_ptr<Vendor::Stub> stub_;
    Store::AsyncService* service_;
    // The producer-consumer queue where for asynchronous server notifications.
    ServerCompletionQueue* cq_;
    CompletionQueue* ccq_;
    // Context for the rpc, allowing to tweak aspects of it such as the use
    // of compression, authentication, as well as to send metadata back to the
    // client.
    ServerContext ctx_;

    // What we get from the client.
    ProductQuery request_;
    // What we send back to the client.
    ProductReply reply_;

    // The means to get back to the client.
    ServerAsyncResponseWriter<ProductReply> responder_;

    // Let's implement a tiny state machine with the following states.
    enum CallStatus { CREATE, PROCESS, FINISH };
    CallStatus status_;  // The current serving state.
  }; // END of Call Data Class

  // This can be run in multiple threads if needed.
  void HandleRpcs() {
    // Spawn a new CallData instance to serve new clients.
    new CallData(&service_, cq_.get());
    void* tag;  // uniquely identifies a request.
    bool ok;
    while (true) {
      // Block waiting to read the next event from the completion queue. The
      // event is uniquely identified by its tag, which in this case is the
      // memory address of a CallData instance.
      // The return value of Next should always be checked. This return value
      // tells us whether there is any kind of event or cq_ is shutting down.
      GPR_ASSERT(cq_->Next(&tag, &ok));
      GPR_ASSERT(ok);
      static_cast<CallData*>(tag)->Proceed();
    }
  }

  std::unique_ptr<ServerCompletionQueue> cq_;
  Store::AsyncService service_;
  std::unique_ptr<Server> server_;
};

int main(int argc, char** argv) {
	StoreImpl server;
  	server.Run();
	std::cout << "I 'm not ready yet!" << std::endl;
	return EXIT_SUCCESS;
}

