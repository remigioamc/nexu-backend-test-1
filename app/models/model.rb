class Model < ApplicationRecord
  belongs_to :brand

  validates :name, :average_price, presence: true
  validates :average_price, numericality: { greater_than_or_equal_to: 100000 }

  after_save :updates_brand_average_price

  scope :price_between, lambda{ |min = 0, max = Float::INFINITY| where(monthly_payment: min..max)}

  private

  def updates_brand_average_price
    brand.update_average_price
  end
end
