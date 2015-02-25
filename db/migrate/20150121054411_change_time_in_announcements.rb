class ChangeTimeInAnnouncements < ActiveRecord::Migration
  def change
    change_column :announcements, :time, :decimal
  end
end
