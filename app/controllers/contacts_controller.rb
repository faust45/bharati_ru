class ContactsController < ApplicationController
  free_actions :feedback, :post_msg, :on_other_sites, :links

  def feedback
    @feedback = FeedbackMsg.new
  end

  def post_msg
    @feedback = FeedbackMsg.new(params[:feedback_msg])

    if @feedback.valid?
      FeedbackMailer.feedback(@feedback).deliver
      flash[:notice] = "Ок"
      redirect_to feedback_path
    else
      render :feedback
    end
  end

  def on_other_sites
  end

  def links
  end

end
