class ResourceFile < ActiveRecord::Base

  has_attached_file :document,

    :url => "/:class/:filename",
    :path => ":rails_root/public/system/:class/:attachment/:id_partition/:style/:filename"

  validates_attachment :document, content_type: {content_type: ["application/pdf"]}
end