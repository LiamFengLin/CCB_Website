class AddFileTypeAndHasThumbNailToResourceFiles < ActiveRecord::Migration
  def change
    add_column :resource_files, :has_thumbnail, :boolean
    add_column :resource_files, :extension, :string
  end
end
