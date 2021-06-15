class ProductCategory < ApplicationRecord
  has_many :product_category_promotions
  has_many :promotions, through: :product_category_promotions

  validates :name,
            :code,
            presence: { message: 'não pode ficar em branco' }

  validates :code, uniqueness: { message: 'deve ser único' }
end
