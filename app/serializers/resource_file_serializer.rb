class ResourceFileSerializer < ActiveModel::Serializer

  include ActiveModel::Serialization

  attributes :id, :file_name

end
