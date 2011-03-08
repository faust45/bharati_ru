class User
  include DataMapper::Resource
  include ZeroAuth

  class AccessDenided < Exception
  end

  property :full_name, String
  property :settings,  Object 
  property :photo_id,  String 

  attr_accessor :photo_file
  attr_accessor :accept_rules


  def save
    save_photo
    super
  end

  def to_s
    login 
  end

  def build_comment(attrs)
    comment = Forum::Comment.new(attrs)
    comment.author_id = self.id

    comment
  end

  def build_post(attrs)
    post = Forum::Post.new(attrs)
    post.author_id = self.id

    post
  end

  def is_owner?(item)
    self.id == item.owner_id
  end

  def is_owner!(item)
    raise Doc::NotFound unless is_owner?(item) 
  end

  def <<(item)
    item.owner_id = self.id

    if item.respond_to?(:owner_display_name)
      item.owner_display_name = self.login
    end
  end

  protected
    def save_photo
      if photo_file
        photo = Photo.create(photo_file)
        Photo.destroy(self.photo_id)

        self.photo_id = photo.id
      end
    end
end
