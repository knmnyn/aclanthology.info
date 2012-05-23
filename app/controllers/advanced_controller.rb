class AdvancedController < BlacklightAdvancedSearch::AdvancedController

  blacklight_config.configure do |config|
    # name of Solr request handler, leave unset to use the same one as your Blacklight.config[:default_qt]
    config.advanced_search.qt = 'advanced'

    ##
    # The advanced search form displays facets as a limit option.
    # By default it will use whatever facets, if any, are returned
    # by the Solr qt request handler in use. However, you can use
    # this config option to have it request other facet params than
    # default in the Solr request handler, in desired.
    config.advanced_search.form_solr_parameters = {}

    # name of key in Blacklight URL, no reason to change usually.
    config.advanced_search.url_key = 'advanced'

    # We are going to completely override the inherited search fields
    config.search_fields.clear

    config.add_search_field 'author' do |field|
      field.solr_local_parameters = {
        :pf => "$pf_author",
        :qf => "$qf_author"
      }
    end

    config.add_search_field 'title' do |field|
      field.solr_local_parameters = {
        :pf => "$pf_title",
        :qf => "$qf_title"
      }
    end

  end

end
