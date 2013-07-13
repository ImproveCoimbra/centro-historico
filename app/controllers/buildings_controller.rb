# encoding: UTF-8

class BuildingsController < ApplicationController
  # GET /buildings
  # GET /buildings?mine=true
  # GET /buildings.json
  def index

    north_east = params[:northEast].split(',') if params[:northEast].present?
    south_west = params[:southWest].split(',') if params[:southWest].present?

    if north_east.present? && south_west.present?

      north_east.collect! { |x| x.to_f }
      south_west.collect! { |x| x.to_f }
      #Google uses LatLng, Mongo uses LngLat
      north_east.reverse!
      south_west.reverse!
      @buildings = Building.where(:coordinates => {'$within' => {'$box' => [south_west, north_east]}})
    else
      @buildings = Building.all.desc(:created_at)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json {
        @buildings = @buildings.to_gmaps4rails do |building, marker|
          marker.title building.property.try(:capitalize)
          marker.json({:link => building_url(building)})
        end
        render json: @buildings
      }
      format.xml { render xml: @buildings }
    end
  end

  # GET /buildings/1
  # GET /buildings/1.json
  def show
    @building = Building.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @building }
    end
  end

  # GET /buildings/new
  # GET /buildings/new.json
  def new
    @building = Building.new
    @building.photos.build

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @building }
    end
  end

  # POST /buildings
  # POST /buildings.json
  def create
    @building = Building.new(params[:building])

    if request.env["HTTP_X_FORWARDED_FOR"].present?
      @building.client_ip = request.env["HTTP_X_FORWARDED_FOR"]
    else
      @building.client_ip = request.remote_ip
    end

    respond_to do |format|
      if @building.save
        format.html { redirect_to @building, notice: 'Edifício criado' }
        format.json { render json: @building, status: :created, location: @building }
      else
        @building.photos.build if @building.photos.empty?
        format.html { render action: "new" }
        format.json { render json: @building.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /buildings/1/edit?token=ABCDE
  def edit
    @building = Report.find_by(:id => params[:id])
  end

  # PUT /buildings/1
  # PUT /buildings/1.json
  def update
    @building = Building.find_by(:id => params[:id])
    @building.save
    respond_to do |format|
      if @building.save
        format.html { redirect_to @building, notice: t(:update_report) }
        format.json { render json: @building.errors, status: :unprocessable_entity }
      else
        # TODO
      end
    end
  end

end
