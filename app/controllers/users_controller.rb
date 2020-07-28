class UsersController < ApplicationController
  before_action :signed_in_user
  before_action :authenticate_admin!, only: %i(index update password_update)
  before_action :set_user, only: %i(show end_tasks update password_update)
  before_action :signed_in_correct_user, only: %i(show end_tasks)
  before_action :pca_api
  
  def index
    @users = User.all.page(params[:page]).per(10)
  end
  
  def show
    @search_params = consignment_search_params
    @search_none = consignment_search_none
    @user_consignments = @search_none ? @user.consignments.where(done: false).search(@search_params).page(params[:page]).per(10).order(ship_date: :desc).order(code: :desc) : 
                               @user.consignments.where(done: false).search(@search_params).order(ship_date: :desc).order(code: :desc)
    # @user_consignments = @user.consignments.where(done: false).page(params[:page]).per(10).order(ship_date: :desc).order(created_at: :desc)
    # @user_consignments = @user.consignments.page(params[:page]).per(10).order(ship_date: :desc).order(created_at: :desc)
  end
  
  def end_tasks
    # @user_consignments = @user.consignments.where(done: true).page(params[:page]).per(10).order(ship_date: :desc).order(created_at: :desc)
    @search_params = consignment_search_params
    @search_none = consignment_search_none
    @user_consignments = @search_none ? @user.consignments.where(done: true).search(@search_params).page(params[:page]).per(10).order(ship_date: :desc).order(code: :desc) : 
                               @user.consignments.where(done: true).search(@search_params).order(ship_date: :desc).order(code: :desc)
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:notice] = "【#{format("%03d", @user.code)}】#{@user.name}の情報を更新しました。"
      redirect_to users_url
    elsif @user.name.blank?
      flash[:alert] = "更新に失敗しました。<br>" + @user.errors.full_messages.join("<br>")
      redirect_to users_url
    else
      flash[:alert] = "#{@user.name}の更新に失敗しました。<br>" + @user.errors.full_messages.join("<br>")
      redirect_to users_url
    end
  end
  
  def password_update
    if @user.update_attributes(user_password_params)
      flash[:notice] = "【#{format("%03d", @user.code)}】#{@user.name}のパスワードを更新しました。"
      redirect_to users_url
    else
      flash[:alert] = "#{@user.name}の更新に失敗しました。<br>" + @user.errors.full_messages.join("<br>")
      redirect_to users_url
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:code, :name, :email, :password, :password_confirmation)
    end
    
    def user_password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
    # 検索用
    def consignment_search_params
      params.fetch(:search, {}).permit(:customer_code, :customer_name, :product_code, :product_name)
    end
end
