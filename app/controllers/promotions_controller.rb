class PromotionsController < ApplicationController
  before_action :authenticate_user!, only: %i[index show new create edit update destroy]
  before_action :set_promotion, only: %i[generate_coupons]
  def index
    @promotions = Promotion.all
  end

  def index
    @promotions = Promotion.all
  end

  def show
    @promotion = Promotion.find(params[:id])
  end

  def search
    if params[:q].blank?
      flash[:notice] = 'Pesquisa em branco'
      redirect_to promotions_path
    else
      @coupons = Coupon.where(code: params[:q])
      @promotions = Promotion.where(name: params[:q])
    end
  end

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = Promotion.create(promotion_params)
    @promotion.user = current_user
    if @promotion.save
      redirect_to @promotion
    else
      render :new
    end
  end

  def edit
    @promotion = Promotion.find(params[:id])
  end

  def update
    @promotion = Promotion.find(params[:id])

    if @promotion.update(promotion_params)
      redirect_to promotion_path
    else
      render :edit
    end
  end

  def destroy
    @promotion = Promotion.find(params[:id])
    @promotion.destroy
    redirect_to promotions_path
  end

  def generate_coupons
    @promotion.generate_coupons!
    flash[:notice] = 'Cupons gerados com sucesso'
    redirect_to @promotion
  end

  def approved
    @promotion = Promotion.find(params[:id])
    @promotion.user_approved = current_user
    @promotion.update!(approved_at: DateTime.current)
    flash[:notice] = 'Promoção aprovada com sucesso'
    @promotion.approved!
    render :show
  end

  private

  def promotion_params
    params
      .require(:promotion)
      .permit(:name, :description, :code,
              :discount_rate, :expiration_date,
              :coupon_quantity, product_category_ids: [])
  end

  def set_promotion
    @promotion = Promotion.find(params[:id])
  end
end
