class TransactionsController < ApplicationController
  before_action :authenticate_request

  def index
    render json: @current_user.transactions.as_json(
      include: { 
        product: { only: [:id, :name, :price] }, 
        credit_card: { only: [:id, :card_number] }
      }
    )
  end
  
  def show
    render json: Transaction.find(params[:id]).as_json(
      include: { 
        product: { only: [:id, :name, :price] },
        credit_card: { only: [:id, :card_number] }
      }
    )
  end

  def create
    @product = Product.find(params[:transaction][:product_id])
    @credit_card = @current_user.credit_cards.find(params[:transaction][:credit_card_id])      
    if @product.quantity < params[:transaction][:quantity].to_i
      render json: { error: "Not enough stock" }, status: :unprocessable_entity
      return
    end

    @transaction = @current_user.transactions.build(transaction_params)
    @transaction.product = @product
    @transaction.credit_card = @credit_card      

    if @transaction.save
      @product.update(quantity: @product.quantity - @transaction.quantity)
      render json: { 
        message: 'Purchase successful', 
        transaction: @transaction 
      }, status: :created
    else
      render json: { 
        errors: @transaction.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end
    
  private    

  def transaction_params
    params.require(:transaction).permit(:quantity, :product_id, :credit_card_id)
  end
  
  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_user
  end
end
