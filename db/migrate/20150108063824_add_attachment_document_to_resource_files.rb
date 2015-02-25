class AddAttachmentDocumentToResourceFiles < ActiveRecord::Migration
  def self.up
    change_table :resource_files do |t|
      t.attachment :document
    end
  end

  def self.down
    remove_attachment :resource_files, :document
  end
end
