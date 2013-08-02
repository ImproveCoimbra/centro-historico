# encoding: UTF-8

class Building
  include Mongoid::Document
  include Mongoid::Paranoia
  include Mongoid::Timestamps

  PROPERTY_VALUES = %w(público privado)
  AVAILABILITY_VALUES = %w(venda arrendamento ocupado)
  CONSERVATION_VALUES = %w(ruína devoluto aceitável bom)
  FUNCTIONS_VALUES = %w(armazenamento comércio habitação hotelaria restauração serviços desocupado)

  field :property,     :type => String
  field :availability, :type => String
  field :conservation, :type => String
  field :functions,    :type => Array
  field :link,         :type => String
  field :description,  :type => String

  field :coordinates, :type => Array
  field :client_ip, :type => String

  index({:coordinates => "2d"})

  embeds_many :photos, :class_name => 'BuildingPhoto', :cascade_callbacks => true

  accepts_nested_attributes_for :photos

  validates :coordinates, presence: true
  validate  :validate_coordinates_format

  # Gmaps4Rails
  acts_as_gmappable :process_geocoding => false

  # Callbacks
  before_save :convert_location

  scope :coimbra, where(:coordinates => {'$within' => {'$box' => [[-8.921616737389286, 40.10956171052814], [-8.343146888756473, 40.2397146010789] ]}})

  def convert_location
    self.coordinates.map! { |c| c.to_f }
  end

  def validate_coordinates_format
    if self.coordinates.size != 2
      errors.add(:coordinates, I18n.t(:invalid_size))
    end

    begin
      self.coordinates.each { |x| Float(x) }
    rescue
      errors.add(:coordinates, I18n.t(:invalid_format))
    end
  end

  def functions
    self[:functions].try(:join, ', ')
  end

  def functions=(items)
    if items.is_a? Array
      self[:functions] = items
    elsif items.is_a? String and items.present?
      self[:functions] = items.split(',').map(&:strip).reject(&:blank?)
    else
      self[:functions] = []
    end
  end

  # Methods
  def as_json(ctx)
    super(:include => {:photos => {:only => [:_id], :methods => :styles}}, :except => [:client_ip])
  end

  def to_xml(options={})
    options.merge!(:include => {:photos => {:only => [:_id], :methods => :styles}}, :except => [:client_ip])
    super(options)
  end

  def latitude
    coordinates[1] if coordinates
  end

  def longitude
    coordinates[0] if coordinates
  end

  def gmaps4rails_infowindow
    content = ""
    content += "<p><b>Propriedade:</b> #{property}</p>" if property.present?
    content += "<p><b>Disponibilidade:</b> #{availability}</p>" if availability.present?
    content += "<p><b>Funções:</b> #{functions}</p>" if functions.present?
    content += "<p><b>Conservação:</b> #{conservation}</p>" if conservation.present?
    content += "<p><b>Comentários:</b> #{description}</p>" if description.present?
    content += "<p><b>Adicionado em:</b> #{created_at.strftime('%Y-%m-%d %H:%M')}</p>"
    content += "<p><a href=\"#{link}\">Mais infomações</a></p>" if link.present?
    if photos.any?
      content += '<ul class="thumbnails">'
      photos.each do |photo|
        content += "<li><a href=\"#{photo.attachment.url(:original)}\" target=\"_blank\" class=\"thumbnail\"><img src=\"#{photo.attachment.url(:medium)}\"/></a></li>"
      end
      content += '</ul>'
    end
    "<div class=\"map-balloon\">#{content}</div>"
  end

  def picture(criteria = 'conservation')
    {
      :picture => icon(criteria),
      :width => 12,
      :height => 12
    }
  end

  def icon(criteria = 'conservation')

    colors = {
      'conservation' => {
        'ruína'     => 'red',
        'devoluto'  => 'orange',
        'aceitável' => 'yellow',
        'bom'       => 'green'
      },
      'property' => {
        'público' => 'red',
        'privado' => 'green',
      },
      'availability' => {
        'venda'        => 'orange',
        'arrendamento' => 'yellow',
        'ocupado'      => 'red',
      }
    }

    if colors[criteria] and colors[criteria][send(criteria)]
      color = colors[criteria][send(criteria)]
    else
      color = 'gray'
    end

    ActionController::Base.helpers.asset_path "dot-#{color}.png"
  end

end
