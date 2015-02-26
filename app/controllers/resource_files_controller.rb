require 'fileutils'
require 'RMagick'

class ResourceFilesController < ApplicationController

  @@dropbox_prefix = '/CCB/Case Books/'
  @@filesys_prefix = '/downloads/'

  def index
    resource_files = ResourceFile.all
    render json: {resource_files: ActiveModel::ArraySerializer.new(resource_files, each_serializer: ResourceFileSerializer).as_json }
  end

  # pdf = Magick::ImageList.new("doc.pdf")
  # thumb = pdf.scale(300, 300)
  # thumb.write "doc.png"

  def show
    file_name = params[:file_name]
    @resource_file = ResourceFile.where(file_name: file_name).first
    if @resource_file and File.exist?(@resource_file.document.path.to_s)
      send_file(@resource_file.document.path, :type => "application/pdf", :disposition => "inline")
    end
    # if file not in server, fetch from dropbox
    dropbox_relative_url = @@dropbox_prefix + file_name
    full_url = client.media(dropbox_relative_url)["url"]
    destination_dir_path = Rails.root.to_s + @@filesys_prefix
    destination_file_full_path = destination_dir_path + file_name
    unless File.directory?(destination_dir_path)
      FileUtils.mkdir_p(destination_dir_path)
    end
    open(destination_file_full_path, 'wb') do |file|
      file << open(full_url).read
    end
    dp_file = File.open(destination_file_full_path)
    if dp_file
      if @resource_file.nil?
        @resource_file = ResourceFile.create(:file_name => file_name, :document => dp_file)
      else
        if not File.exist?(@resource_file.document.path.to_s)
          @resource_file.update_attributes(document: dp_file)
        end
        if not File.exist?(@resource_file.thumbnail.path.to_s)
          @resource_file.update_attributes(thumbnail: dp_file)
        end
      end
      File.delete(dp_file)
    end
    send_file(@resource_file.document.path, :type => "application/pdf", :disposition => "inline")
  end

  def batch_update
    resource_files_hash = client.metadata(@@dropbox_prefix)['contents'] || []
    resource_files = resource_files_hash.map do |rf|
      name = rf['path'].split('/').last
      ResourceFile.where(file_name: name).first_or_create
    end
    render json: {status: :success}
  end

  def fetch_thumbnail
    @resource_file = ResourceFile.where(file_name: params[:file_name]).first
    if @resource_file
      if File.exist?(@resource_file.thumbnail.path.to_s)
        send_file(@resource_file.thumbnail.path, :type => "image/png", :disposition => "inline")
      end
      if File.exist?(@resource_file.document.path.to_s)
        read_path = @resource_file.document.path.to_s
      else
        dropbox_relative_url = @@dropbox_prefix + file_name
        read_path = client.media(dropbox_relative_url)["url"]
      end
      pdf = Magick::ImageList.new(server_path)
      thumb = pdf.scale(200, 200)
      @resource_file.update_attributes(thumbnail: thumb)
      send_file(@resource_file.thumbnail.path, :type => "image/png", :disposition => "inline")
    end
  end

  private

  def file_dir_path(file_path)
    "".join(file_path.split('/')[0:-1])
  end

  def client
    Rails.application.config.dropbox_client
  end

end