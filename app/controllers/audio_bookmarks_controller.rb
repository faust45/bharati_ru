class AudioBookmarksController < ApplicationController
  layout false

  def create
    audio = Audio.get!(params[:id])
    @bm   = audio.new_bookmark(params[:bookmark])

    current_user << @bm
    @bm.save
  end

  def destroy 
    @bm = current_user.get_audio_bookmark!(params[:bm_id])
    @bm.destroy
  end

  def share
    @bm = current_user.get_audio_bookmark!(params[:bm_id])
    @bm.share!
  end

  def private 
    @bm = current_user.get_audio_bookmark!(params[:bm_id])
    @bm.private!
  end

  def copy
    @bm = current_user.copy_bookmark(params[:bm_id])
  end

end
