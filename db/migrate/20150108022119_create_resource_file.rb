class CreateResourceFile < ActiveRecord::Migration
  def change
    create_table :resource_files do |t|
      t.string :path
      t.timestamps
    end
  end
end
