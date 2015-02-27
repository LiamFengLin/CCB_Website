class ResourceFileSerializer < ActiveModel::Serializer

  include ActiveModel::Serialization

  attributes :id, :file_name, :file_thumbnail_url

end
