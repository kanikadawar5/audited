require 'elasticsearch/persistence'
  class AuditLogs
    include Elasticsearch::Persistence::Repository

    # Customize the serialization logic
    # def serialize(document)
    #   super.merge(my_special_key: 'my_special_stuff')
    # end

    # # Customize the de-serialization logic
    # def deserialize(document)
    #   puts "# ***** CUSTOM DESERIALIZE LOGIC... *****"
    #   super
    # end
    
  end
