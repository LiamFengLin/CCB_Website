class AddAttachmentThumbnailToResourceFiles < ActiveRecord::Migration
  def self.up
    change_table :resource_files do |t|
      t.attachment :thumbnail
    end
  end

  def self.down
    remove_attachment :resource_files, :thumbnail
  end
end
