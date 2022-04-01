class Admin::ImagesController < Admin::BaseController
  before_action :authenticate_user!
  before_action :find_image

  def destroy
    @image.purge
  end

  private

  def find_image
    @image = authorize ActiveStorage::Attachment.find(params[:id]), policy_class: ImagePolicy
  end
end