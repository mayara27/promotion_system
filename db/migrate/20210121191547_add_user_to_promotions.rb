class AddUserToPromotions < ActiveRecord::Migration[6.1]
  def change
    add_reference :promotions, :user, foreign_key: true, default: nil
  end
end
