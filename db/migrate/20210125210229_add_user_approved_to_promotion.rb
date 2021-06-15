class AddUserApprovedToPromotion < ActiveRecord::Migration[6.1]
  def change
    add_reference :promotions, :user_approved, foreign_key: { to_table: :users }
  end
end
