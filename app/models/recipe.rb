class Recipe < ActiveRecord::Base
  attr_accessible :content, :title, :image

  mount_uploader :image, ImageUploader
end
