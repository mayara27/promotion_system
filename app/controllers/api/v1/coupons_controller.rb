class Api::V1::CouponsController < ActionController::API
  def show
    @coupon = Coupon.find_by(code: params[:code])
    return render json: 'Cupom não encontrado', status: :not_found if @coupon.nil?

    render json: @coupon, status: 200
  end

  def burn
    @coupon = Coupon.find_by(code: params[:code])

    @coupon.burn!(params.require(:coupon).permit(:code)[:code])

    render json: 'Cupom utilizado com sucesso', status: :ok
  rescue ActionController::ParameterMissing
    render json: '', status: :precondition_failed
  rescue AtiveRecord::RecordInvalid
    render json: '', status: 422
  end
end
