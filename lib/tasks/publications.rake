
namespace :publications do
  desc "Fetch publications from Scribd"
  task :fetch => :environment do
    scribd_ids = []
    ScribdFu.scribd_user.documents.each do |doc|
      begin
        scribd_ids << doc.doc_id
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

    puts 'Strat remove diff'
    all_ids = Publication.get_all.map(&:ipaper_id)
    to_delete = all_ids - scribd_ids
    puts "diff ids #{to_delete.inspect}"

    to_delete.each do |id|
      pub = Publication.get_by_ipaper_id(id)
      if pub.any?
        pub.first.destroy
      end
    end
  end
end

