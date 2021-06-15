class AddApprovedAtToPromotion < ActiveRecord::Migration[6.1]
  def change
    add_column :promotions, :approved_at, :datetime
  end
end
