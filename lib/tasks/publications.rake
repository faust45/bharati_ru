
namespace :publications do
  desc "Fetch publications from Scribd"
  task :fetch => :environment do
    ScribdFu.scribd_user.documents.each do |doc|
      begin
        Publication.create(
          :title             => doc.title, 
          :ipaper_id         => doc.doc_id, 
          :ipaper_access_key => doc.access_key,
          :description       => doc.description,
          :when_uploaded     => doc.when_uploaded,
          :page_count        => doc.page_count,
          :publication_type  => 'book'
        )
      rescue Publication::Dublicate => ex
      end
    end
  end
end

