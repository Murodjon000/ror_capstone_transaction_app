class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :update, :destroy, :edit]
  before_action :authenticate_user!

  def index
    @transactions = Transaction.includes(:group).where(user_id: current_user.id).grouped
    @transaction_sum = Transaction.where(user_id: current_user.id).grouped.sum(:amount)
  end

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = current_user.transactions.build(transaction_params)

    if @transaction.save
      flash[:success] = 'You created new transaction'
      redirect_to root_path
    else
      flash[:alert] = 'Transaction was not created'
      render :new
    end
  end

  def edit
    @transaction = Transaction.find(params[:id])
  end

  def update
    @transaction = Transaction.find(params[:id])

    if @transaction.update(transaction_params)
        flash[:success] = 'You updated your transaction'
        redirect_to root_path
    else
        flash[:alert] = 'Transaction was not updated'
        render :edit
    end
  end

  def destroy
    Transaction.find(params[:id]).destroy
    flash[:success] = 'Transaction deleted'
    redirect_to root_path
  end

  def external_transaction
    @external_transactions = Transaction.where(user_id: current_user.id).not_grouped
    @external_transactions_sum = Transaction.where(user_id: current_user.id).not_grouped.sum(:amount)
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:name, :amount, :user_id, :group_id)
  end
end