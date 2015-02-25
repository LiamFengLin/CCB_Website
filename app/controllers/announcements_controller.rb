class AnnouncementsController < ApplicationController

  def create
    Announcement.create(announcement_params)
    render json: {status: :success}
  end

  def index
    @announcements = Announcement.all
    render json: {announcements: ActiveModel::ArraySerializer.new(@announcements, each_serializer: AnnouncementSerializer).as_json}
  end

  private 

  def announcement_params
    params.require(:announcement).permit(:name, :time, :description)
  end
end