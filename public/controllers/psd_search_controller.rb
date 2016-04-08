require 'advanced_query_builder'

class SearchController < ApplicationController

  def set_advanced_search_criteria
    set_search_criteria

    terms = (0..4).collect{|i|
      term = search_term(i)

      if term and term["op"] === "NOT"
        term["op"] = "AND"
        term["negated"] = true
      end

	  if term and term["type"] === "date"
        term["comparator"] = params["dop#{i}"]
		if term["value"].length == 4
		  term["value"] = term["value"] + "-01-01"
		elsif term["value"].length == 7
		  term["value"] = term["value"] + "-01"
		end
      end

      term
    }.compact

    if not terms.empty?
      @criteria["aq"] = AdvancedQueryBuilder.new(terms, :public).build_query.to_json
      @criteria['facet[]'] = FACETS
    end
  end

  def thesa_search
    set_advanced_search_criteria

    @search_data = Search.all(@criteria, @repositories)

    render "search/results"
  end
  
  def search_term(i)
    if not params["v#{i}"].blank?
      { "field" => params["f#{i}"], "value" => params["v#{i}"], "op" => params["op#{i}"], "type" => params["t#{i}"] }
    end
  end

end
