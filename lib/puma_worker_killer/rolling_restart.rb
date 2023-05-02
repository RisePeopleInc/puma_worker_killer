# frozen_string_literal: true

module PumaWorkerKiller
  class RollingRestart
    def initialize(master = nil, rolling_pre_term = nil)
      @cluster = PumaWorkerKiller::PumaMemory.new(master)
      @rolling_pre_term = rolling_pre_term
    end

    # used for tes
    def get_total_memory
      @cluster.get_total_memory
    end

    def reap(seconds_between_worker_kill = 60)
      # this will implicitly call set_workers
      total_memory = get_total_memory
      return false unless @cluster.running?

      @cluster.workers.each do |worker, _ram|
        @rolling_pre_term&.call(worker)

        worker.term
        sleep seconds_between_worker_kill
      end
    end
  end
end
