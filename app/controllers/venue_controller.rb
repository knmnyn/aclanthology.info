class VenueController < ApplicationController
  
  include Blacklight::SolrHelper
  include  Blacklight::Solr
  include Blacklight::Catalog

def get_facet_response(facet_field, extra_controller_params={},venue_value)

    solr_params = solr_facet_params(facet_field, extra_controller_params)
    solr_params[:fq] ||= []
    solr_params[:fq] << "{!raw f='venue'}#{venue_value}"
    solr_params[:"f.#{facet_field}.facet.limit"] = 100
    response = find(solr_params)
      return     Blacklight::Solr::FacetPaginator.new(response.facets.first.items,
      :offset => solr_params['facet.offset'],
      :sort => true
       )
end


def index
   #@response,@documents = get_solr_response_for_field_values("author","Anna Korhonen")
   @response,@documents_list = get_solr_response_for_field_values("venue",params[:venue],{:sort=>"year desc"})
   @popular_authors = get_facet_response("author_facet",{},params[:venue])
   @venue = params[:venue]
   
end


end
