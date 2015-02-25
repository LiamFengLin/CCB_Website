class DeleteResourceFile < ActiveRecord::Migration
  def change
    drop_table :resource_fileses
  end
end
