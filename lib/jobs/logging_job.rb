class LoggingJob < ActiveJob::Base
  queue_as :audits

  def perform(audit_info, audit_index_as)
    @audit_info = audit_info
    set_audit_user
    set_remote_address
    set_request_uuid
    set_job_id
    client = Elasticsearch::Client.new(url: "#{ENV['ELASTICSEARCH_URL']}", log: true)
    audit = AuditLogs.new(client: client, index_name: audit_index_as)
    audit.settings number_of_shards: 1 do
      mapping do
        indexes :text, analyzer: 'snowball'
      end
    end
    audit.save(@audit_info)
  end

  private
  def set_audit_user
    @audit_info['user'] ||= ::Audited.store[:audited_user] # from .as_user
    @audit_info['user'] ||= ::Audited.store[:current_user].try!(:call) # from Sweeper
    nil # prevent stopping callback chains
  end

  def set_request_uuid
    @audit_info['request_uuid'] ||= ::Audited.store[:current_request_uuid]
    @audit_info['request_uuid'] ||= SecureRandom.uuid
  end

  def set_remote_address
    @audit_info['remote_address'] ||= ::Audited.store[:current_remote_address]
  end

  def set_job_id
    @audit_info['job_id'] ||= ::Audited.store[:current_job_id]
  end
end
