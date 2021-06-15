class Promotion < ApplicationRecord
  belongs_to :user
  belongs_to :user_approved, class_name: 'User', optional: true

  enum status: { not_approved: 0, approved: 10 }

  has_many :coupons, dependent: :destroy
  has_many :product_category_promotions
  has_many :product_categories, through: :product_category_promotions, dependent: :destroy
  validates :name,
            :code,
            :discount_rate,
            :coupon_quantity,
            :expiration_date,
            presence: { message: 'não pode ficar em branco' }

  validates :code, uniqueness: { message: 'deve ser único' }

  def generate_coupons!
    return raise 'Cupons já foram gerados' if coupons.any?

    coupons
      .create_with(created_at: Time.now, updated_at: Time.now)
      .insert_all!(generate_coupons_code)
  end

  def generate_coupons_code
    (1..coupon_quantity).map do |number|
      { code: "#{code}-#{'%04d' % number}" }
    end
  end

  def expired?
    expiration_date < Date.current
  end
end
