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

  def gmaps4rails_marker_picture
    {
      :picture => gmaps4rails_marker_icon,
      :width => 7,
      :height => 7
    }
  end

  def gmaps4rails_marker_icon
    filename = case conservation
    when 'ruína'     then 'dot-red.png'
    when 'devoluto'  then 'dot-orange.png'
    when 'aceitável' then 'dot-yellow.png'
    when 'bom'       then 'dot-green.png'
    else                  'dot-gray.png'
    end
    ActionController::Base.helpers.asset_path filename
  end

end
