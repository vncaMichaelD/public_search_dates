class CommonIndexer

  self.add_indexer_initialize_hook do |indexer|

    indexer.add_document_prepare_hook {|doc, record|
      if doc['primary_type'] == 'digital_object'
		record["record"]["dates"].each do |alink|
			do_begin_date = fuzzy_time_parse(alink["begin"])
			do_end_date = fuzzy_time_parse(alink["end"])
			if do_begin_date
				doc['begin_u_udate'] = do_begin_date
			end
			if do_end_date
				doc['begin_u_udate'] = do_end_date
			end
		end
      end

      if doc['primary_type'] == 'resource'
		record["record"]["dates"].each do |alink|
			resource_begin_date = fuzzy_time_parse(alink["begin"])
			resource_end_date = fuzzy_time_parse(alink["end"])
			if resource_begin_date
				doc['begin_u_udate'] = resource_begin_date
			end
			if resource_end_date
				doc['begin_u_udate'] = resource_end_date
			end
		end
      end
    }
  end

  def self.fuzzy_time_parse(time_str)
    return if time_str.nil?

    begin
      time = if time_str.length == 4 && time_str[/^\d\d\d\d/]
        Time.parse("#{time_str}-01-01")

      elsif time_str.length == 7 && time_str[/^\d\d\d\d-\d\d/]
        Time.parse("#{time_str}-01")

      else
        Time.parse(time_str)
      end

      "#{time.strftime("%Y-%m-%d")}T00:00:00Z"
    rescue
      nil
    end
  end

end
