require 'active_record'

module Audited
  class << self
    attr_accessor :ignored_attributes, :current_user_method, :max_audits, :auditing_enabled, :audit_index_as
    attr_writer :audit_class

    def audit_class
      @audit_class ||= Audit
    end

    def store
      Thread.current[:audited_store] ||= {}
    end

    def config
      yield(self)
    end
  end

  @ignored_attributes = %w(lock_version created_at updated_at created_on updated_on)

  @current_user_method = :current_user
  @auditing_enabled = true
end

require 'audited/auditor'
require 'audited/audit'
require 'jobs/logging_job'
require 'audited/audit_logs'

::ActiveRecord::Base.send :include, Audited::Auditor

require 'audited/sweeper'
