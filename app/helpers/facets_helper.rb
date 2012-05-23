module FacetsHelper
  include Blacklight::FacetsHelperBehavior

# Render a collection of facet fields
  def render_facet_partials fields = facet_field_names, options = {}
    solr_fields = fields.map { |solr_field| facet_by_field_name(solr_field) }.compact

    solr_fields.map do |display_facet|
       render_facet_limit(display_facet, options)
    end.compact.join("\n").html_safe
  end

  def sort_facet_year(items=[])
      items.sort{|a,b| b.value <=> a.value }
  end
  def render_facet_value_venue(facet_solr_field, item, hits,title, options ={})
    (link_to_unless(options[:suppress_link], item, add_facet_params_and_redirect(facet_solr_field, item), :class=>"facet_select label",:title=>title) + " " + render_facet_count(hits)).html_safe
  end

  def render_selected_facet_value_venue(facet_solr_field, item, hits, title)
      content_tag(:span, render_facet_value_venue(facet_solr_field, item, hits,title,:suppress_link => true), :class => "selected label",:title=>title) +
      link_to("[remove]", remove_facet_params(facet_solr_field, item, params), :class=>"remove")
  end

def sort_facet_venues(paginator_items)
    paginator_sort = {'CL'=>1,'ACL'=>2,'EACL'=>3,'NAACL'=>4,'EMNLP'=>5,'ANLP'=>6,'SEMEVAL'=>7,'COLING'=>8,'RANLP'=>9,'HLT'=>10,'LREC'=>11,'IJCNLP'=>12,
    'PACLIC'=>13,'ROCLING'=>14,'TINLAP'=>15,'TIPSTER'=>16,'ALTA'=>17,'MUC'=>18}

    index=0
    items=[]
    paginator_items.each do |paginator_item|
      items[index]=paginator_item.value
      index += 1
    end

   workshops=[]
   conferences=[]
   items.each do |item|
        if paginator_sort.has_key? item
            conferences.push item
        else
            workshops.push item
	end
   end

    for i in 0..conferences.length-1
      for j in 1..(conferences.length-i-1)
        if paginator_sort[conferences[j-1]] > paginator_sort[conferences[j]]
          temp=conferences[j-1]
          conferences[j-1] = conferences[j]
          conferences[j] = temp
        end
      end
   end

    items=[]
    if workshops.include? ("Others")
      workshops[workshops.index("Others")], workshops[workshops.length-1] = workshops[workshops.length-1], workshops[workshops.index("Others")]
    end
    items.push conferences
    items.push workshops
    return items.flatten
  end


  def sort_facet_hits(paginator_items)
    paginator_sort = {'CL'=>1,'ACL'=>2,'EACL'=>3,'NAACL'=>4,'EMNLP'=>5,'ANLP'=>6,'SEMEVAL'=>7,'COLING'=>8,'RANLP'=>9,'HLT'=>10,'LREC'=>11,'IJCNLP'=>12,
    'PACLIC'=>13,'ROCLING'=>14,'TINLAP'=>15,'TIPSTER'=>16,'ALTA'=>17,'MUC'=>18}

    index=0
    items=[]
    hits=[]
    paginator_items.each do |paginator_item|
        items[index]=paginator_item.value
        hits[index]=paginator_item.hits
        index += 1
    end
    conferences = []
    conferences_hits=[]
    workshops = []
    workshops_hits=[]
    for index in 0..items.length-1
        if paginator_sort.has_key? items[index]
            conferences.push items[index]
	    conferences_hits.push hits[index]
        else
            workshops.push items[index]
	    workshops_hits.push hits[index]
	end
    end

    for i in 0..conferences.length-1
      for j in 1..(conferences.length-i-1)
        if paginator_sort[conferences[j-1]] > paginator_sort[conferences[j]]
            temp=conferences_hits[j-1]
            conferences_hits[j-1] = conferences_hits[j]
            conferences_hits[j] = temp

            temp_item=conferences[j-1]
            conferences[j-1] = conferences[j]
            conferences[j] = temp_item
        end
      end
    end
    hits = []
    if workshops.include? ("Others")
      workshops_hits[workshops.index("Others")], workshops_hits[workshops.length-1] = workshops_hits[workshops.length-1], workshops_hits[workshops.index("Others")]
    end
    hits.push conferences_hits
    hits.push workshops_hits
    return hits.flatten
  end


end 
