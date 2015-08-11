require 'monitor'
require 'thread'

module Dwek
  class ParallelMapping

    END_OF_QUEUE = Class.new
    WORKER_COUNT = 6

    def initialize(mapper)
      work_queue = SizedQueue.new(WORKER_COUNT)
      workers = Array.new(WORKER_COUNT)

      workers.extend(MonitorMixin)
      workers_available = workers.new_cond
      available_pred = ->(thread){ thread.nil? || thread.status == false || !thread['finished'].nil? }

      completed = false

      conn = ActiveRecord::Base.connection
      conn_mutex = Mutex.new

      results = []
      results_mutex = Mutex.new

      consumer_thread = Thread.new do
        while !completed || work_queue.length > 0
          index = nil
          workers.synchronize do
            workers_available.wait_while do
              workers.none?(&available_pred)
            end
            index = workers.rindex(&available_pred)
          end

          workers[index] = Thread.new(work_queue.pop) do |subject_id|
            conn_mutex.synchronize do
              puts conn.columns('temp_table_subjects').size
            end
            results_mutex.synchronize do
              results << subject_id
            end 
            Thread.current['finished'] = true

            workers.synchronize do
              workers_available.signal
            end
          end
        end
      end

      producer_thread = Thread.new(Dwek::Subject.table.ids) do |subject_ids|
        subject_ids.each do |subject_id|
          work_queue << subject_id

          workers.synchronize do
            workers_available.signal
          end
        end
        completed = true
      end

      producer_thread.join
      consumer_thread.join(5)
      workers.each { |thread| thread.join(5) unless thread.nil? }

      puts results.length.inspect
      puts results.join(',')
    end
  end
end
