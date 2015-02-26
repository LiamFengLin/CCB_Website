class ResourceFile < ActiveRecord::Base

  has_attached_file :document,
    :url => "documents/:class/:style/:filename",
    :path => ":rails_root/public/system/attachments/:style/:filename"

  has_attached_file :thumbnail,
    :styles => {
        :thumb => "200x200#",
    },
    :url => "thumbnails/:class/:filename",
    :path => ":rails_root/public/system/thumbnails/:filename"    

  validates_attachment :document, content_type: {content_type: ["application/pdf"]}
end