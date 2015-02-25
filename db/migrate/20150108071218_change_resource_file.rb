class ChangeResourceFile < ActiveRecord::Migration
  def change
    rename_column :resource_files, :path, :file_name
  end
end
