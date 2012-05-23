class PeopleController < ApplicationController
  
  include Blacklight::SolrHelper
  include  Blacklight::Solr
  include Blacklight::Catalog

def get_facet_response(facet_field, extra_controller_params={})

    solr_params = solr_facet_params(facet_field, extra_controller_params)
    solr_params[:"f.#{facet_field}.facet.limit"] = 100
    response = find(solr_params)
      return     Blacklight::Solr::FacetPaginator.new(response.facets.first.items,
      :offset => solr_params['facet.offset'],
      :sort => true
       )
end


def index
   #@response,@documents = get_solr_response_for_field_values("author","Anna Korhonen")
   @response,@documents = get_solr_response_for_field_values("author",params[:author],{:sort=>"year desc",:rows=>200})

   #gets the faceted values of a search param
   @year_facets = get_facet_response("year",{:q=>params[:author]}) 
   @venue_facets = get_facet_response("venue",{:q=>params[:author]}) 
   @author_facets = get_facet_response("author_facet",{:q=>params[:author]}) 
   @author = params[:author]
  end

end
