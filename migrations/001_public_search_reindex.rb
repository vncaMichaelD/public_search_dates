require 'db/migrations/utils'

Sequel.migration do

  up do

    # Trigger a reindex for affected record types
    now = Time.now
    [:digital_object, :resource].each do |table|
      self[table].update(:system_mtime => now)
    end

  end

end
