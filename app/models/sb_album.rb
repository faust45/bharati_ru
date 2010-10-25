class SbAlbum < BaseModel
  use_as_id :gen_id

  TITLE = /^Шримад Бхагаватам.*?Книга/

  property :title
  property :description
  property :author_id
  property :is_hand_sort, :default => false 
  property :tracks, [], :default => []
  property :book_num 

  timestamps!

  has_photo_attachment :cover, :thumb => {:size => 'x77'}

  before_create :assign_book_num
  before_create :cleanup_title


  class<< self 

    def get_all
      view_docs('sb_albums_all')
    end

    def get_by_title(title)
      id = gen_id(title)
      self.get_doc(id)
    end

    def gen_id(title)
      title.match(/^Шримад Бхагаватам. Книга\s*(\d+)/)
      "SbBook#{$1}"
    end

    def rework
      get_all.each do |doc|
        p(doc.id)
        doc.delete('_id')
        doc.delete('_rev')
        doc.delete('couchrest-type')
        doc['tracks'] = doc.tracks.to_a
        doc['cover_attachments'] = doc.cover_attachments.to_a

        self.create(doc)
      end
    end
  end

  def gen_id
    self.class.gen_id(title)
  end

  private
    def assign_book_num
      title.match(/^Шримад Бхагаватам. Книга\s*(\d+)/)
      self.book_num = $1
    end

    def cleanup_title
      title.sub!(/^Шримад Бхагаватам. Книга\s*(\d+)/, '')
      title.gsub!(/"/, '')
      title.strip!
    end
end
