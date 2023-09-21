class Brand < ApplicationRecord
  has_many :models, dependent: :destroy

  validates :name, presence: true

  def update_average_price
    update!(average_price: models.average(:average_price))
  end
end
