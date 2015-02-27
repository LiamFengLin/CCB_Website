require 'fileutils'
require 'RMagick'

class ResourceFilesController < ApplicationController

  @@dropbox_prefix = '/CCB/Case Books/'
  @@filesys_prefix = '/downloads/'
  @@destination_dir_path = Rails.root.to_s + @@filesys_prefix

  def index
    resource_files = ResourceFile.all
    render json: {resource_files: ActiveModel::ArraySerializer.new(resource_files, each_serializer: ResourceFileSerializer).as_json }
  end

  def show
    file_name = params[:file_name]
    @resource_file = ResourceFile.where(file_name: file_name).first
    if @resource_file and File.exist?(@resource_file.document.path.to_s)
      send_file(@resource_file.document.path, :type => "application/pdf", :disposition => "inline")
      return
    end
    # if file not in server, fetch from dropbox
    dropbox_relative_url = @@dropbox_prefix + file_name
    full_url = client.media(dropbox_relative_url)["url"]

    destination_file_full_path = @@destination_dir_path + file_name
    unless File.directory?(@@destination_dir_path)
      FileUtils.mkdir_p(@@destination_dir_path)
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
      end
      File.delete(dp_file)
    end
    send_file(@resource_file.document.path, :type => "application/pdf", :disposition => "inline")
  end

  def batch_update
    resource_files_hash = client.metadata(@@dropbox_prefix)['contents'] || []
    resource_files = resource_files_hash.map do |rf|
      name = rf['path'].split('/').last
      @resource_file = ResourceFile.where(file_name: name).first_or_create
      if ENV['RAILS_ENV'] == 'production'  
        domain_url = "http://consulting.berkeley.edu/"
      else
        domain_url = "http://localhost:3000/"
      end
      file_url = domain_url + "resource_files/" + name
      file_thumbnail_url = domain_url + "resource_files/" + name + "/fetch_thumbnail"
      @resource_file.update_attributes(file_url: file_url, file_thumbnail_url: file_thumbnail_url)
    end
    render json: {status: :success}
  end

  def fetch_thumbnail
    file_name = params[:resource_file_file_name]
    @resource_file = ResourceFile.where(file_name: file_name).first
    if @resource_file
      if File.exist?(@resource_file.thumbnail.path.to_s)
        send_file(@resource_file.thumbnail.path, :type => "image/png", :disposition => "inline")
        return
      end
      if File.exist?(@resource_file.document.path.to_s)
        read_path = @resource_file.document.path.to_s + "[0]"
      else
        dropbox_relative_url = @@dropbox_prefix + file_name
        read_path = client.media(dropbox_relative_url)["url"] + "[0]"
      end
      thumb = Magick::ImageList.new(read_path).scale(200, 200)
      
      destination_file_full_path = @@destination_dir_path + file_without_extension(file_name) + ".png"
      unless File.directory?(@@destination_dir_path)
        FileUtils.mkdir_p(@@destination_dir_path)
      end
      thumb.write(destination_file_full_path)
      thumb_file = File.open(destination_file_full_path)

      @resource_file.update_attributes(thumbnail: thumb_file)
      # File.delete(thumb_file)
      send_file(@resource_file.thumbnail.path, :type => "image/png", :disposition => "inline")
    end
  end

  private

  def file_dir_path(file_path)
    file_path.split('/')[0...-1].join("")
  end

  def file_without_extension(file_name)
    file_name.split(".")[0...-1].join("")
  end

  def client
    Rails.application.config.dropbox_client
  end

end