class ResourceFilesController < ApplicationController

  @@dropbox_prefix = '/CCB/Case Books/'
  @@filesys_prefix = '/downloads/'

  def index
    resource_files = ResourceFile.all
    render json: {resource_files: ActiveModel::ArraySerializer.new(resource_files, each_serializer: ResourceFileSerializer).as_json }
  end

  def show
    file_name = params[:file_name]
    @resource_file = ResourceFile.where(file_name: file_name).first
    unless @resource_file.nil? or (not @resource_file.document.file?)
      send_file(@resource_file.document.path, :type => "application/pdf", :disposition => "inline")
    end

    dropbox_relative_url = @@dropbox_prefix + file_name
    full_url = client.media(dropbox_relative_url)["url"]
    destination_file_full_path = Rails.root.to_s + @@filesys_prefix + file_name
    open(destination_file_full_path, 'wb') do |file|
      file << open(full_url).read
    end
    dp_file = File.open(destination_file_full_path)
    if dp_file
      if @resource_file.nil?
        @resource_file = ResourceFile.create(:file_name => file_name, :document => dp_file)
      elsif not @resource_file.document.file?
        @resource_file.update_attributes(document: dp_file)
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

  private

  def client
    Rails.application.config.dropbox_client
  end

end