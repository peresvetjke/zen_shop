module ImagesHelper

  def google_image_src(google_image_id:, size: 250)
    "https://drive.google.com/thumbnail?id=#{google_image_id}&sz=w#{size}-h#{size}"
  end
end