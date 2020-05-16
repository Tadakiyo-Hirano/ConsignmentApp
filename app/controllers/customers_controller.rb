class CustomersController < ApplicationController
  before_action :signed_in_user
  before_action :set_customer, only: %i()
  
  def index
    @customers = Customer.all.page(params[:page]).per(10).order(code: :asc)
  end
  
  def show
  end
  
  def new
  end
  
  def create
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
  end
end
