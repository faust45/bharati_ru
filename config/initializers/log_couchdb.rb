module CouchDbInstrumentation
  class LogSubscriber < ActiveSupport::LogSubscriber
    def self.runtime=(value)
      Thread.current["couchdb_runtime"] = value
    end

    def self.runtime
      Thread.current["couchdb_runtime"] ||= 0
    end

    def self.reset_runtime
      rt, self.runtime = runtime, 0
      rt
    end
    
    def query(event)
      self.class.runtime += event.duration
      return unless logger.debug?

      name = '%s (%.1fms)' % ["CouchDb Query", event.duration]

      query = event.payload[:query].map{ |k, v| "#{k}: #{color(v, BOLD, true)}" }.join(', ')

      debug "  #{color(name, YELLOW, true)}  [ #{query} ]"
    end
  end

  module ControllerRuntime
    extend ActiveSupport::Concern

    protected

    def append_info_to_payload(payload)
      super
      payload[:couchdb_runtime] = CouchDbInstrumentation::LogSubscriber.runtime
    end

    module ClassMethods
      def log_process_action(payload)
        messages, couchdb_runtime = super, payload[:couchdb_runtime]
        messages << ("CouchDb: %.1fms" % couchdb_runtime.to_f) if couchdb_runtime
        messages
      end
    end
  end
end

CouchDbInstrumentation::LogSubscriber.attach_to :couchdb

ActiveSupport.on_load(:action_controller) do
  include CouchDbInstrumentation::ControllerRuntime
end
