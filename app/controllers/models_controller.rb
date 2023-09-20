class ModelsController < ApplicationController
  def index
    greater = params[:greater] if params[:greater]
    lower = params[:lower] if params[:lower]
    models = nil

    if greater && lower
      models_greater_lower = Model.where("average_price > ? AND average_price < ?", greater, lower)
      models = models_greater_lower
    elsif greater
      models_greater = Model.where("average_price > ?", greater) if greater
      models = models_greater
    else
      models_lower = Model.where("average_price < ?", lower) if lower
      models = models_lower
    end
    render json: models
  end

  def show
    brand = Brand.find(params[:id])
    msg = {}

    msg = brand.nil? ? not_found_msg(brand) : brand_found_msg(brand)
    render json: msg, status: msg[:status]
  end

  def create
    params_allowed = permitted_params
    brand = Brand.find_by(id: params[:id])

    return render json: {msg: "Brand with ID: #{params[:id]} Not Found", status: 404 }, status_code: 404 if brand.nil?

    car_model = brand.models.new(name: params_allowed[:name].capitalize, average_price: params_allowed[:average_price])

    msg = {}

    begin
      car_model.save!
      msg = success_msg_response(car_model, "added")
    rescue ActiveRecord::RecordNotUnique => e
      msg = failure_msg_response(car_model, "Name already in Use")
    end

    render json: msg, status: msg[:status_code]
  end

  def update
    car_model = Model.find(params[:id])
    return render json: {msg: "Model with ID: #{params[:id]} Not Found", status: 404 }, status_code: 404 if car_model.nil?

    params_allowed = permitted_params
    car_model.update(params_allowed)
    msg = {}

    begin
      car_model.save!
      msg = success_msg_response(car_model, "updated")
    rescue
      msg = failure_msg_response(car_model, "Not updated")
    end

    render json: msg, status: msg[:status_code]
  end

  private

  def success_msg_response(model, action)
    {
      msg: "Successfully #{action}",
      status_code: 200,
      model: model
    }
  end

  def failure_msg_response(model, reason)
    {
      msg: "Request failed",
      reason: reason,
      status_code: 401,
      model: model

    }
  end

  def model_not_found_msg(brand)
    {
      msg: "Brand #{brand} not found",
      status_code: 404
    }
  end

  def brand_found_msg(brand)
    models = brand.models

    if models.any?
      {
        msg: "Success",
        status_code: 200,
        models: models
      }
    else
      {
        msg: "No models found for the brand #{brand}",
        status_code: 404
      }
    end
  end

  def permitted_params
    params.require(:model).permit(:name, :average_price)
  end 
end
