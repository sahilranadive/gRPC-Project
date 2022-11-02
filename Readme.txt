Team Members: Sahil Ashish Ranadive, Samina Shiraj Mulani


References used 

* https://stackoverflow.com/questions/15752659/thread-pooling-in-c11 

* https://grpc.io/docs/languages/cpp/async/ 

* https://github.com/grpc/grpc/blob/v1.50.0/examples/cpp/helloworld/greeter_async_client2.cc 

* https://github.com/grpc/grpc/blob/v1.50.0/examples/cpp/helloworld/greeter_async_server.cc 

 

Async Calls as a Server and Client 

Note: The class store has been renamed to StoreImpl for better readability. 

CallData is a nested class within StoreImpl, an instance of which is responsible for handling one client. The server is asynchronous and continuously reads from its completion queue for the following events – * Population of context, request and responder after an RPC event has been requested 

* Completion of the RPC.  

There is only one common completion queue for all the clients. The tag for an event is a pointer to the CallData instance responsible for the client. This instance could be in one of three states – CREATE, PROCESS, and FINISH.  

In the CREATE state, the main thread requests for an RPC event.  

The PROCESS state indicates that a client request has arrived. In this state, a new CallData instance is created to request another RPC event and the current client uses a thread from the threadpool to begin the task of asynchronously sending requests to vendors. Another thread is created that waits for replies from the vendors and populates the reply_ data structure of the CallData instance. This wait is done on a completion queue that is unique for each client (but common for all replies received from the vendors for the product queried by the client). After sending all requests, we wait until the aforementioned thread has been completed. The status is then set to FINISH and the gRPC runtime is informed that the client request has finished.  

Related functions - 

    void makeAsyncClientCalls() - The job queued by the threads in a threadpool. Responsible for asynchronously sending requests to all vendors and utilizing another thread to wait and process replies from the vendors. 

    void SendRequestToVendor(string product_name, unique_ptr<Vendor::Stub> &stub) - initiates the RPC call to one vendor given the respective stub for the vendor. Handles storing of reply by having the tag of the event as an AsyncClientCall (a structure defined inside CallData) object that holds the reply and status of the response from the vendor. 

    void AsyncCompleteRpc() - For a client, reads all replies for the product from all the vendors. 

In the FINISH state, we delete the instance of CallData that was handling the client as processing is done. 

 

Threadpool  

The threadpool in <threadpool.h> has been renamed ThreadPool and an object corresponding to this class has been created in store.cc.  

The structure of ThreadPool contains the following functions: 

Public: 

    Start (): Initializes a vector of threads and passes the “ThreadLoop” function to each of the threads as the task that they must perform. 

    QueueJob (const function<void ()>& job): Takes in a function (in our case “makeAsyncClientCalls” as the function) to be run in the thread in parallel and queues it so that the threadpool can pick it up when a thread is available. 

    Stop (): Stops all the threads by joining all of them. Essentially cleans up the threadpool. 

Private: 

    ThreadLoop(): The function passed to each thread in the threadpool upon initialization. It waits while the queue is empty and when there is some work to be done (as seen in the queue), it picks it up and executes it, then goes back and waits for other tasks to be populated in the queue. 

ThreadPool also uses the following variables: 

    should_terminate: A Boolean value that tells the ThreadLoop that cleanup is happening, and it should stop waiting for more tasks to be populated in the queue 

    queue_mutex: A mutex variable that allows us to take locks on operations to the queue (prevents data race between reads and writes to the queue)             

    mutex_condition:  Allows threads to wait on new jobs or termination  
    vector threads: An array of threads initialized to contain the number of threads passed as an argument to the store program 

    queue<function<void()>> jobs: A queue that takes in the jobs populated through the QueueJob function and allows threads to pick up the oldest function to be executed. 
     