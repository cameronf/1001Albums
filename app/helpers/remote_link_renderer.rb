# app/helpers/remote_link_renderer.rb

class RemoteLinkRenderer < WillPaginate::ActionView::LinkRenderer
  def prepare(collection, options, template)
    @remote = options.delete(:remote) || {}
    super
  end

protected
  def link(text, page, attributes = {})
    @template.content_tag :span, text.to_s.html_safe, :class => 'remote_link', :onclick => 'do_js_get_paged_albums('+page.to_s+',\''+@remote[:update]+'\')'
  end
end
