require 'pp'

module SyslogTls
  class HostBackoffSpecs
    attr_accessor :retriesToDo, :hostIPport

    def initialize(retries_to_do, host_ip_port)
      @retriesToDo = retries_to_do
      @hostIPport = host_ip_port
      @failTime = nil
      @baseThreshold = 2
    end

    def canwrite
      time_passed_since_failure = -1
      if @failTime != nil
        time_passed_since_failure = Time.now - @failTime
        time_passed_since_failure = time_passed_since_failure.round(2)
      end
      if time_passed_since_failure == -1
        return 1
      end
      backoffTime = @baseThreshold ** @retriesToDo
      if backoffTime > 3600
        backoffTime = 3600
      end
      if time_passed_since_failure > backoffTime
        pp "canwrite writting after backoff :: time_passed_since_failure" + time_passed_since_failure.to_s + " time :: " + Time.now.to_s
        return 1
      else
        return 0
      end
    end

    def failtowrite
      @retriesToDo += 1
      @failTime = Time.now
    end

    def resetRetries
      @retriesToDo = 0
      @failTime = nil
    end
  end
end
