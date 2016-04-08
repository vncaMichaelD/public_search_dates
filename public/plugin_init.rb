my_routes = [File.join(File.dirname(__FILE__), "routes.rb")]
ArchivesSpacePublic::Application.config.paths['config/routes'].concat(my_routes)

ArchivesSpacePublic::Application.config.after_initialize do
 
   # Force the module to load
   ApplicationHelper

 module ApplicationHelper

  def params_for_search(opts = {})
    search_params = {
      :controller => :search,
      :action => :search
    }

    search_params["filter_term"] = Array(opts["filter_term"] || params["filter_term"]).clone
    search_params["filter_term"].concat(Array(opts["add_filter_term"])) if opts["add_filter_term"]
    search_params["filter_term"] = search_params["filter_term"].reject{|f| Array(opts["remove_filter_term"]).include?(f)} if opts["remove_filter_term"]

    search_params["sort"] = opts["sort"] || params["sort"]

    search_params["q"] = opts["q"] || params["q"]

    search_params["format"] = params["format"]
    search_params["root_record"] = params["root_record"]
    search_params["agent_type"] = params["agent_type"]

    search_params["page"] = opts["page"] || params["page"] || 1

    if opts["type"] && opts["type"].kind_of?(Array)
      search_params["type"] = opts["type"]
    else
      search_params["type"] = opts["type"] || params["type"]
    end

    search_params["term_map"] = params["term_map"]

    # retain any advanced search params
    advanced = (opts["advanced"] || params["advanced"])
    search_params["advanced"] = advanced.blank? || advanced === 'false' ? false : true
    search_params[:action] = :advanced_search if search_params["advanced"]
	thesa = (opts["thesa"] || params["thesa"])
    search_params["thesa"] = thesa.blank? || thesa === 'false' ? false : true
    search_params[:action] = :advanced_search if search_params["thesa"]
	operation = (opts["operation"] || params["operation"])
    search_params["operation"] = operation.blank? || operation === 'false' ? false : true
    search_params[:action] = :advanced_search if search_params["operation"]
    
    (0..4).each do |i|
      search_params["v#{i}"] = params["v#{i}"]
      search_params["f#{i}"] = params["f#{i}"]
      search_params["op#{i}"] = params["op#{i}"]
	  search_params["dop#{i}"] = params["dop#{i}"]
	  search_params["t#{i}"] = params["t#{i}"]
    end

    search_params.reject{|k,v| k.blank? or v.blank?}
  end

 end

 
end

