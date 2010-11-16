class ContactsController < ApplicationController
  free_actions :feedback, :post_msg

  def feedback
    @feedback = FeedbackMsg.new
  end

  def post_msg
    @feedback = FeedbackMsg.new(params[:feedback_msg])

    if @feedback.save
      flash[:notice] = "Ок"
      redirect_to feedback_path
    else
      render :feedback
    end
  end

  def other_sites
  end

  def links

  end

end
