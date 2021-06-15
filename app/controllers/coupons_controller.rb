class CouponsController < ApplicationController
  def inactivate
    @coupon = Coupon.find(params[:id])
    flash[:notice] = t('.success')
    @coupon.inactive!
    redirect_to @coupon.promotion
  end

  def activate
    @coupon = Coupon.find(params[:id])
    flash[:notice] = t('.success_activate')
    @coupon.active!
    redirect_to @coupon.promotion
  end
end
