class FileStorage
  def self.upload_public_file(file_name, file_path)
    obj = S3_BUCKET.object(file_name)
    obj.upload_file(file_path, acl: 'public-read')

    obj.public_url
  end
end