Paperclip::Attachment.default_options.merge!(
  :storage => :s3,
  :s3_credentials => "#{Rails.root}/config/s3.yml",
  :path => "/:class/:style/:id/:filename"
)
