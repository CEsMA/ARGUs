# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def sort_td_class_helper(param)
    result = 'class="sortup"' if params[:sort] == param
    result = 'class="sortdown"' if params[:sort] == param + "_reverse"
    return result
  end

  
  def sort_link_helper(text, param)
    key = param
    key += "_reverse" if params[:sort] == param
    options = {
        :url => {:action => 'list', :params => params.merge({:sort => key, :page => nil})},
        :update => 'table',
        :before => "Element.show('spin')",
        :loading => visual_effect(:appear, 'spin', :duration => 2.0),
        :complete => visual_effect(:fade, 'spin', :duration => 1.0)
    }
    html_options = {
      :title => "Ordenar por este dato",
      :href => url_for(:action => 'list', :params => params.merge({:sort => key, :page => nil}))
    }
    link_to_remote(text, options, html_options)
  end

end
