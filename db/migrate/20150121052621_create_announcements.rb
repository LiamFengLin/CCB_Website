class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :name
      t.datetime :time
      t.string :description
      t.timestamps
    end
  end
end
