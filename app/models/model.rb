class Model < ApplicationRecord
  belongs_to :brand

  validates :name, :average_price, presence: true
  validates :average_price, numericality: { greater_than_or_equal_to: 100000 }

  after_save :updates_brand_average_price

  private

  def updates_brand_average_price
    brand = Brand.find(self.brand_id)
    models = brand.models
    brand.average_price = models_average_price(models)
    brand.save!
  end

  def models_average_price(models)
    total_models_average_price = 0

    models.each do |model|
      total_models_average_price += model.average_price
    end

    total_models_average_price / models.size
  end
end
