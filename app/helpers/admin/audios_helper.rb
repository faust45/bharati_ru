module Admin::AudiosHelper

  def prepare_sub_nav
    content_for :audios_nav do
      render :partial => 'sub_nav'
    end
  end

end
