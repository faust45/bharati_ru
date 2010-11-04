module PublicationsHelper
  Available_JS_Params = [ :height, :width, :page, :my_user_id, :search_query,
                          :jsapi_version, :disable_related_docs, :mode, :auto_size ]
  TYPES = {
    'book' => 'книга',
    'article' => 'статья'
  }

  def bhagavatam_cover
    @@bhagavatam ||= Publication.get_all_bhagavatam(:limit => 1)
    cover_thumb @@bhagavatam.first
  end

  def cover_thumb(publication)
    photo_thumb(publication.cover, {:width =>91, :height => 119}, true)
  end

  def publication_type(publication)
    TYPES[publication.publication_type]
  end

  def display_ipaper(doc, options = {})
    html =
    <<-END
      <script type="text/javascript" src="http://www.scribd.com/javascripts/view.js"></script>
      <div id="embedded_flash">#{options.delete(:alt)}</div>
      <script type="text/javascript">
        var scribd_doc = scribd.Document.getDoc(#{doc.ipaper_id}, '#{doc.ipaper_access_key}');
        #{js_params(options)}
        scribd_doc.write("embedded_flash");
      </script>
    END

    html.html_safe
  end


  # Check and collect any Javascript params that might have been passed in
  def js_params(options)
    opt = []

    options.each_pair do |k, v|
      opt << "scribd_doc.addParam('#{k}', '#{v}');" if Available_JS_Params.include?(k)
    end

    opt.compact.join("\n")
  end
end
