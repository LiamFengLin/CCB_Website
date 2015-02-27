class AddFileThumbnailUrlToResourceFiles < ActiveRecord::Migration
  def change
    add_column :resource_files, :file_url, :string
    add_column :resource_files, :file_thumbnail_url, :string
  end
end
