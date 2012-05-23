module ApplicationHelper

  include Blacklight::Solr
  include Blacklight::CatalogHelperBehavior

def render_author_index_field_value args
  value = args[:value]
  value ||= args[:document].get(args[:field]) if args[:document] and args[:field]
  authors = value.split(/ +, +/) if args[:field] == 'author'
end
def get_venue_title venue
              venue_titles = {'semeval'=>"International Workshop on Semantic Evaluation (formerly Workshop on Sense Evaluation)",
                              'naacl'=>"North American Chapter of ACL",
                              'eacl'=>"European Chapter of ACL",
                              'cl'=>"Computational Linguistics Journal",
                              'acl'=>"ACL Annual Meeting",
                              'anlp'=>"Applied Natural Language Processing Conference",
                              'emnlp'=>"Conference on Empirical Methods in Natural Language Processing (and forerunners)",
                              'workshops'=>"Complete workshop listing",
                              'coling'=>"Int'l Committee on Computational Linguistics (ICCL) Conf.",
                              'hlt'=>"Human Language Technology Conf.",
                              'ijcnlp'=>"Int'l Joint Conf. on Natural Language Processing (and workshops)",
                              'alta'=>"Australasian Language Technology Association Workshop",
                              'lrec'=>"International Conference on Language Resources and Evaluation",
                              'ranlp'=>"International Conference Recent Advances in Natural Language Processing",
                              'paclic'=>"Pacific Asia Conference on Language, Information and Computation",
                              'rocling'=>"Rocling Computation Linguistics Conference and Journal",
                              'muc'=>"Message Understanding Conf.",
                              'tinlap'=>"Theoretical Issues In Natural Language Processing",
                              'tipster'=>"NIST's TIPSTER text program"}
                return venue_titles[venue]
end

def get_paper_title(paper_id)
  paper_id=paper_id
  solr_response = force_to_utf8(Blacklight.solr.find({:qt=>:document,:id=>paper_id}))
  raise Blacklight::Exceptions::InvalidSolrID.new if solr_response.docs.empty? 
  document_list = solr_response.docs.collect{|doc| SolrDocument.new(doc, solr_response) }
  document = SolrDocument.new(solr_response.docs.first, solr_response)
  return document.get("title")
end

def paginate_rsolr_params(response)
  per_page = response.rows
  per_page = 1 if per_page < 1
  current_page = (response.start / per_page).ceil + 1
  num_pages = (response.total / per_page.to_f).ceil
  Struct.new(:current_page, :num_pages, :limit_value).new(current_page, num_pages, per_page)
end

def paginate_rsolr_response(response, options = {}, &block)
  paginate paginate_params(response), options, &block
end

def get_trend_papers
    t_papers =[]
    file_path =  "app/trends/trending_papers"
    file = File.open(file_path,'r')
    file.each{ |line| t_papers << line.strip
    }
    return t_papers
end
def get_trend_authors
    t_authors =[]
    file_path = "app/trends/trending_authors"
    file = File.open(file_path,'r')
    file.each{ |line| t_authors << line.strip
    }
    return t_authors
end

def force_to_utf8(value)
  case value
  when Hash
    value.each { |k, v| value[k] = force_to_utf8(v) }
  when Array
    value.each { |v| force_to_utf8(v) }
  when String
    value.force_encoding("utf-8")  if value.respond_to?(:force_encoding)
  end
  value
end

end
