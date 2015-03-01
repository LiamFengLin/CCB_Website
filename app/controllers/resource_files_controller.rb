require 'fileutils'
require 'RMagick'

class ResourceFilesController < ApplicationController

  @@dropbox_prefix = '/CCB/Case Books/'
  @@filesys_prefix = '/downloads/'
  @@destination_dir_path = Rails.root.to_s + @@filesys_prefix
  HAS_THUMBNAIL_TYPES = ["pdf"]
  DEFAULT_THUMBNAIL_PATH = Rails.root.to_s() + "/app/assets/images/default_audio_thumbnail.png"
  EXT_TO_HTML_TYPE = {"pdf" => "application/pdf", "mp3" => "audio/mp3"}

  def index
    resource_files = ResourceFile.all
    render json: {resource_files: ActiveModel::ArraySerializer.new(resource_files, each_serializer: ResourceFileSerializer).as_json }
  end

  def show
    file_name = params[:file_name]
    @resource_file = ResourceFile.where(file_name: file_name).first
    if @resource_file and File.exist?(@resource_file.document.path.to_s)
      send_file(@resource_file.document.path, :type => EXT_TO_HTML_TYPE[@resource_file.extension], :disposition => "inline", :x_sendfile => true)
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
    send_file(@resource_file.document.path, :type => EXT_TO_HTML_TYPE[@resource_file.extension], :disposition => "inline", :x_sendfile => true)
  end

  def batch_update
    resource_files_hash = client.metadata(@@dropbox_prefix)['contents'] || []
    file_names_in_dropbox = resource_files_hash.map do |rf|
      rf['path'].split('/').last
    end
    file_names_in_server = ResourceFile.all.map do |rf|
      rf.file_name
    end
    # delete unwanted set on server
    (file_names_in_server - file_names_in_dropbox).each do |name|
      ResourceFile.delete(file_name: name)
    end
    # add new files to server and update attributes
    resource_files = file_names_in_dropbox.each do |name|
      @resource_file = ResourceFile.where(file_name: name).first_or_create
      if (not @resource_file.extension) or (not @resource_file.has_thumbnail)
        extension = file_extension(name)
        @resource_file.update_attributes(extension: extension, has_thumbnail: HAS_THUMBNAIL_TYPES.include?(extension))
      end
      file_url = "/resource_files/" + name
      file_thumbnail_url = "/resource_files/" + name + "/fetch_thumbnail"
      @resource_file.update_attributes(file_url: file_url, file_thumbnail_url: file_thumbnail_url)
    end
    render json: {status: :success}
  end

  def fetch_thumbnail
    file_name = params[:resource_file_file_name]
    main_file_name = file_without_extension(file_name)
    extension = file_extension(file_name)
    @resource_file = ResourceFile.where(file_name: file_name).first
    if @resource_file
      if not @resource_file.has_thumbnail
        # if no thumbnail, send default thumbnail
        send_file(DEFAULT_THUMBNAIL_PATH, :type => "image/png", :disposition => "inline", :x_sendfile => true)
        return
      elsif File.exist?(@resource_file.thumbnail.path.to_s)
        # thumbnail exists
        send_file(@resource_file.thumbnail.path, :type => "image/png", :disposition => "inline", :x_sendfile => true)
        return
      end
      # thumbnail does not exist
      if File.exist?(@resource_file.document.path.to_s)
        # document exist on server
        read_path = @resource_file.document.path.to_s + "[0]"
      else
        # document exist on dropbox
        dropbox_relative_url = @@dropbox_prefix + file_name
        read_path = client.media(dropbox_relative_url)["url"] + "[0]"
      end
      thumb = Magick::ImageList.new(read_path).scale(200, 200)
      
      destination_file_full_path = @@destination_dir_path + main_file_name + ".png"
      unless File.directory?(@@destination_dir_path)
        FileUtils.mkdir_p(@@destination_dir_path)
      end
      thumb.write(destination_file_full_path)
      thumb_file = File.open(destination_file_full_path)

      @resource_file.update_attributes(thumbnail: thumb_file)
      File.delete(thumb_file)
      send_file(@resource_file.thumbnail.path, :type => "image/png", :disposition => "inline", :x_sendfile => true)
    end
  end

  private

  def file_dir_path(file_path)
    file_path.split('/')[0...-1].join("")
  end

  def file_without_extension(file_name)
    file_name.split(".")[0...-1].join("")
  end

  def file_extension(file_name)
    file_name.split(".")[-1]
  end

  def client
    Rails.application.config.dropbox_client
  end

end