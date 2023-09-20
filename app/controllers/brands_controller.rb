class BrandsController < ApplicationController
  def index
    brands = Brand.all
    render json: brands
  end

  def create
    brand_name = permitted_params[:name].capitalize
    brand = Brand.new(name: brand_name)
    msg = {}

    begin
      brand.save!
      msg = success_msg_response(brand)
    rescue ActiveRecord::RecordNotUnique => e
      msg = failure_msg_response(brand)
    end

    render json: msg, status: msg[:status]
  end

  private

  def success_msg_response(brand)
    {
      brand: brand,
      msg: "Successfully added",
      status: 200
    }
  end

  def failure_msg_response(brand)
    {
      brand: brand,
      msg: "Name already in Use",
      status: 401
    }
  end
  
  def permitted_params
    params.require(:brand).permit(:name)
  end
end
