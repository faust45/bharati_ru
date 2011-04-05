class User
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include DataMapper::Resource
  include ZeroAuth

  class AccessDenided < Exception
  end

  DEFULT_AVATAR = '049fffa63d1df3efbdc424bdea77a420'

  property :full_name, String
  property :settings,  Object
  property :photo_id,  String 
  property :roles,     Object, :default => Set.new 
  property :sex ,       Enum['w', 'm', 'any'], :default => 'any'
  property :birthday,   Date
  property :conseption, String 
  property :activities, String 
  property :interests,  String 
  property :about_me,   String 
  property :phone,      String 
  property :site,       String 
  property :skype,      String 
  property :created_at, DateTime 
   

  attr_accessor :photo_file
  attr_accessor :accept_rules

  def update(attrs)
    year, month, day = attrs.delete('birthday(1i)'), attrs.delete('birthday(2i)'), attrs.delete('birthday(3i)')

    if year && month && day
      date = Date.new(year.to_i, month.to_i, day.to_i)
      attrs[:birthday] = date
    end

    super(attrs)
  end

  def age
    if self.birthday
      Date.today.year - self.birthday.year
    end
  end

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

  def logger
    Rails.logger
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

  def persisted?
    !new? 
  end

  def to_param
    login
  end

  def total_stat
    unless @total_stat
      @total_stat = OpenStruct.new

      post_stat = Forum::Comment.view('forum_comments', :key => ['User', 'Post', self.id], :reduce => true)
      comment_stat = Forum::Comment.view('forum_comments', :key => ['User', 'Comment', self.id], :reduce => true)
      msg = Forum::Comment.view('forum_comments',
                                :key => ['User', 'Any', self.id], :descending => true, :limit => 1, :include_docs => true)

      doc = msg['rows'][0]
      @total_stat.posts    = post_stat['rows'][0]['value'] || 0
      @total_stat.comments = comment_stat['rows'][0]['value'] || 0

      @total_stat.last_activ = doc && DateTime.parse(doc['doc']['created_at'])
    end

    @total_stat
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
