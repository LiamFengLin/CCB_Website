class ResourceFile < ActiveRecord::Base

  has_attached_file :document,
    :path => ":rails_root/public/system/attachments/:style/:filename"

  has_attached_file :thumbnail,
    :path => ":rails_root/public/system/thumbnails/:filename"    

  validates_attachment :document, content_type: {content_type: ["application/pdf", "audio/mp3", 'application/mp3', 'application/x-mp3', 'audio/mpeg']}
end