class BuildingPhoto
  include Mongoid::Document
  include Mongoid::Paperclip

  embedded_in :building, :inverse_of => :photos

  has_mongoid_attached_file :attachment, :styles => {#:thumb => '40x40#',
                                                     #:small => '100x100#',
                                                     :medium => '400x400>',
                                                     :large => '1024x1024>'
  }
  attr_accessible :attachment

  def styles
    Hash[(self.attachment.styles.keys + [:original]).map { |style| [style, self.attachment.url(style)] }]
  end
end
