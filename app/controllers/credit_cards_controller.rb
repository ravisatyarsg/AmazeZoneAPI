class CreditCardsController < ApplicationController
  before_action :authenticate_request     

  def index
    render json: @current_user.credit_cards
  end

  def show
    render json: CreditCard.find(params[:id])
  end

  def create
    @credit_card = @current_user.credit_cards.build(credit_card_params)
    if @credit_card.save
      render json: @credit_card, status: :created
    else
      render json: { errors: @credit_card.errors.full_messages }, 
                   status: :unprocessable_entity
    end
  end
  
  def destroy
    CreditCard.find(params[:id]).destroy
    head :no_content
  end
  
  private
  
  def credit_card_params
    params.require(:credit_card).permit(:name, :card_number, :expiration_date, :cvv)
  end
  
  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_user
  end
end
