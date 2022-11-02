#include "threadpool.h"

#include <iostream>
#include <bits/stdc++.h>
#include <grpc++/grpc++.h>
#include "store.grpc.pb.h"
#include "vendor.grpc.pb.h"
#include <fstream>

using grpc::Server;
using grpc::ServerAsyncResponseWriter;
using grpc::ServerBuilder;
using grpc::ServerCompletionQueue;
using grpc::ServerContext;
using grpc::Status;
using grpc::Channel;
using grpc::ClientAsyncResponseReader;

using vendor::BidQuery;
using vendor::BidReply;
using vendor::Vendor;
using store::ProductQuery;
using store::ProductReply;
using store::ProductInfo;
using store::Store;
using grpc::CompletionQueue;
using grpc::ClientContext;

using namespace std;


class StoreImpl final : public Store::AsyncService{ 
	public:
	~StoreImpl() {
		server_->Shutdown();
		// Shutdown the completion queue after the server.
		cq_->Shutdown();
    // Stop the threadpool
    threadpool.Stop();
	}

  int getVendorAddresses(std::string filename)
  {
    std::ifstream myfile (filename);
    if (myfile.is_open()) {
      std::string v_addr;
      while (getline(myfile, v_addr)) {
        vendorAddresses.push_back(v_addr);
      }
      myfile.close();
    }
    else
      return -1; // failure
    return 0; // success
  }
	
	void Run(string vendor_addresses_path_, string server_address_, int max_threads) {
    std::string server_address(server_address_);
    
    threadpool.Start(max_threads);

    int errCode = getVendorAddresses(vendor_addresses_path_); 
    if(errCode == -1)
    {
      std::cout<<"Could not get vendor addresses\n";
      return;
    }
    for(auto vendorAddr: vendorAddresses) // stubs for all the vendors are created once when server is started
    {
      std::shared_ptr<Channel> channel = grpc::CreateChannel(vendorAddr, grpc::InsecureChannelCredentials());
      stubs_.push_back(Vendor::NewStub(channel));
    }

    ServerBuilder builder;
    // Listen on the server address without any authentication mechanism
    builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
    // service_ corresponds to an asynchronous service
    builder.RegisterService(&service_);
    // Server completion queue (one common queue for all clients)
    cq_ = builder.AddCompletionQueue();
    // Assemble the server.
    server_ = builder.BuildAndStart();
    std::cout << "Server listening on " << server_address << std::endl;

    // Proceed to the server's main loop.
    HandleRpcs();
  }

  private:
  // Class encompasing the state (minimal) and logic needed to serve a request.
  class CallData {
   public:
    // Take in the "service" instance (in this case representing an asynchronous
    // server), the completion queue "cq" used for asynchronous communication
    // with the gRPC runtime, the stubs for all the vendors and the threadpool instance.
    CallData(Store::AsyncService* service, ServerCompletionQueue* cq,std::vector<std::unique_ptr<Vendor::Stub>> *stubs, ThreadPool *threadpool)
        : service_(service), cq_(cq), responder_(&ctx_), status_(CREATE), stubs_(stubs), threadpool_(threadpool) {
      // Invoke the serving logic right away.
      Proceed();
    }

    void Proceed() {
      if (status_ == CREATE) {
        // Make this instance progress to the PROCESS state.
        status_ = PROCESS;

        // As part of the initial CREATE state, we *request* that the system wait
        // for a getProducts RPC event. In this request, "this" acts as 
        // the tag uniquely identifying the request (so that different CallData
        // instances can serve different requests concurrently); in this case
        // the memory address of this CallData instance.
        service_->RequestgetProducts(&ctx_, &request_, &responder_, cq_, cq_,
                                  this);
      } else if (status_ == PROCESS) {
        // Spawn a new CallData instance to serve new clients while we process
        // the one for this CallData. The instance will deallocate itself as
        // part of its FINISH state.
        new CallData(service_, cq_, stubs_, threadpool_);

        // The actual processing.
        threadpool_->QueueJob([this](){this->makeAsyncClientCalls();});
        
      } else {
        GPR_ASSERT(status_ == FINISH);
        // Once in the FINISH state, deallocate ourselves (CallData).
        delete this;
      }
    }

    void AsyncCompleteRpc() {
      void* got_tag;
      bool ok = false;
      int numVendors = stubs_->size();

      // Block until the next result is available in the completion queue ccq_ and there are still replies from vendors to be read
      while (numVendors>0 && ccq_.Next(&got_tag, &ok)) {
        // The tag in this example is the memory location of the call object
        AsyncClientCall* call = static_cast<AsyncClientCall*>(got_tag);

        // Verify that the request was completed successfully.
        GPR_ASSERT(ok);

        if (call->status.ok())
        {
          store::ProductInfo* productInfo = reply_.add_products();
          productInfo->set_price(call->bidReply.price());
          productInfo->set_vendor_id(call->bidReply.vendor_id());
          numVendors--;
        }

        // Once we're complete, deallocate the call object.
        delete call;
      }
    }

    void SendRequestToVendor(std::string product_name, std::unique_ptr<Vendor::Stub> &stub) {
      // Data we are sending to the server.
      BidQuery bidQueryRequest;
      bidQueryRequest.set_product_name(product_name);

      // Call object to store rpc data
      AsyncClientCall* call = new AsyncClientCall;

      // stub->PrepareAsyncgetProductBid() creates an RPC object, returning
      // an instance to store in "call" but does not actually start the RPC
      // Because we are using the asynchronous API, we need to hold on to
      // the "call" instance in order to get updates on the ongoing RPC.
      call->response_reader = stub->PrepareAsyncgetProductBid(&call->context, bidQueryRequest, &ccq_);

      // StartCall initiates the RPC call
      call->response_reader->StartCall();

      // Request that, upon completion of the RPC, "reply" be updated with the
      // server's response; "status" with the indication of whether the operation
      // was successful. Tag the request with the memory address of the call
      // object.
      call->response_reader->Finish(&call->bidReply, &call->status, (void*)call);
    }

    void makeAsyncClientCalls()
    {
      // Starting up the thread to wait for replies from the vendors
      std::thread thread_ = std::thread(&CallData::AsyncCompleteRpc, this);
      std::string  product_name = request_.product_name();
      // Sending requests to all vendors
      for(auto stub=stubs_->begin();stub!=stubs_->end();stub++)
      {
        SendRequestToVendor(product_name, *stub);
      }
      // Wait till all replies have been handled
      thread_.join(); 

      // Let the gRPC runtime know we've finished, using the
      // memory address of the CallData instance as the uniquely identifying tag for
      // the event.
      status_ = FINISH;
      responder_.Finish(reply_, Status::OK, this);
    }

   private:

   struct AsyncClientCall {
      // Container for the data we expect from the server.
      BidReply bidReply;

      // Context for the client. It could be used to convey extra information to
      // the server and/or tweak certain RPC behaviors.
      ClientContext context;

      // Storage for the status of the RPC upon completion.
      Status status;

      std::unique_ptr<ClientAsyncResponseReader<BidReply>> response_reader;
    };

    // The means of communication with the gRPC runtime for an asynchronous
    // server.
    Store::AsyncService* service_;

    // Completion queue for vender-store communication
    CompletionQueue ccq_;
    // Stubs for vendors
    std::vector<std::unique_ptr<Vendor::Stub>>* stubs_;

    // The producer-consumer queue where for asynchronous server notifications.
    ServerCompletionQueue* cq_;
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

    enum CallStatus { CREATE, PROCESS, FINISH };
    CallStatus status_;  // The current serving state.
    ThreadPool* threadpool_;
  }; // END of Call Data Class

  void HandleRpcs() {
    // Spawn a new CallData instance to serve new clients.
    new CallData(&service_, cq_.get(), &stubs_, &threadpool);
    void* tag;  // uniquely identifies a request.
    bool ok;
    while (true) {
      // Block waiting to read the next event from the completion queue. The
      // event is uniquely identified by its tag, which in this case is the
      // memory address of a CallData instance.
      GPR_ASSERT(cq_->Next(&tag, &ok));
      GPR_ASSERT(ok);
      static_cast<CallData*>(tag)->Proceed();
    }
  }

  std::unique_ptr<ServerCompletionQueue> cq_;
  Store::AsyncService service_;
  std::unique_ptr<Server> server_;
  std::vector<string> vendorAddresses;
  std::vector<std::unique_ptr<Vendor::Stub>> stubs_;
  ThreadPool threadpool;
};

int main(int argc, char** argv) {
  string vendor_addresses_path, server_address;
  int max_threads;
  vendor_addresses_path = argv[1];
  server_address = argv[2];
  max_threads = stoi(argv[3]);
	StoreImpl server;
  server.Run(vendor_addresses_path, server_address, max_threads);
	return EXIT_SUCCESS;
}

