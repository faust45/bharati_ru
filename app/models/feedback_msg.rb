class FeedbackMsg < BaseModel
  use_time_id

  property :name
  property :mail
  property :topic
  property :body
  property :is_read

  validates_presence_of :name, :mail, :body

  class<< self 
    def get_all
      view_docs('feedback_msgs')
    end
  end

end
