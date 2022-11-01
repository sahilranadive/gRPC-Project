#pragma once
#include <thread>
#include <mutex>
#include <bits/stdc++.h>

using namespace std;

class ThreadPool {
  public:
    ThreadPool() {

    } 
    void Start(uint32_t n_threads) {
      uint32_t num_threads = std::thread::hardware_concurrency(); // Max # of threads the system supports
      num_threads = std::min(num_threads, n_threads);
      threads.resize(num_threads);

      for (uint32_t i = 0; i < num_threads; i++) {
          threads.at(i) = std::thread(&ThreadPool::ThreadLoop, this);
      }
    }

    void QueueJob(const std::function<void()>& job) {
        {
            std::unique_lock<std::mutex> lock(queue_mutex);
            jobs.push(job);
        }
        cout<<"added job to queue. Queue Size: "<<jobs.size()<<endl;
        mutex_condition.notify_one();
    }

    void Stop() {
      {
        std::unique_lock<std::mutex> lock(queue_mutex);
        should_terminate = true;
      }
      mutex_condition.notify_all();
      for (std::thread& active_thread : threads) {
          active_thread.join();
      }
      threads.clear();
    }
    bool busy() {
      bool poolbusy;
      {
          std::unique_lock<std::mutex> lock(queue_mutex);
          poolbusy = jobs.empty();
      }
      return poolbusy;
    }

    void ThreadLoop() {
      while (true) {
        std::function<void()> job;
        {
            std::unique_lock<std::mutex> lock(queue_mutex);
            mutex_condition.wait(lock, [this] {
                return !jobs.empty() || should_terminate;
            });
            if (should_terminate) {
                return;
            }
            cout<<"picked up a job"<<endl;
            job = jobs.front();
            jobs.pop();
        }
        job();
      }
    }

    bool should_terminate = false;           // Tells threads to stop looking for jobs
    std::mutex queue_mutex;                  // Prevents data races to the job queue
    std::condition_variable mutex_condition; // Allows threads to wait on new jobs or termination 
    std::vector<std::thread> threads;
    std::queue<std::function<void()>> jobs;
};
