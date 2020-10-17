class UsersController < ApplicationController
  before_action :signed_in_user
  before_action :authenticate_admin!, only: %i(create update password_update destroy)
  before_action :set_user, only: %i(show end_tasks update password_update destroy)
  before_action :signed_in_correct_user, only: %i(show end_tasks)
  # before_action :signed_in_correct_user_or_admin, only: %i(show end_tasks)
  
  
  def index
    @users = User.all.page(params[:page]).order(code: :asc)
  end
  
  def show
    redirect_to users_url if admin_signed_in?
    @search_params = consignment_search_params
    @search_none = consignment_search_none
    @user_consignments = @search_none ? @user.consignments.where(done: false).search(@search_params).page(params[:page]).per(10).order(ship_date: :desc).order(product_code: :desc).order(created_at: :desc) : 
                               @user.consignments.where(done: false).search(@search_params).order(ship_date: :desc).order(product_code: :desc).order(created_at: :desc)
  end
  
  def end_tasks
    @search_params = consignment_search_params
    @search_none = consignment_search_none
    @user_consignments = @search_none ? @user.consignments.where(done: true).search(@search_params).page(params[:page]).per(10).order(ship_date: :desc).order(code: :desc) : 
                               @user.consignments.where(done: true).search(@search_params).order(ship_date: :desc).order(code: :desc)
  end
  
  def update
    if @user.update_attributes(user_params)
      # ユーザーモデル(User)を更新した場合、委託(モデルconsignment)の、担当者名(user_name)も同時更新する。
      Consignment.where(['user_id == ?', @user.id]).update_all(user_name: User.find(@user.id).name) if Consignment.where(user_id: @user.id).present?
      flash[:notice] = "【#{format("%03d", @user.code)}】#{@user.name}の情報を更新しました。"
      if admin_signed_in?
        redirect_to users_url
      else
        redirect_to @user
      end
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
  
  def destroy
    @user.destroy
    flash[:alert] = "【#{format("%03d", @user.code)}】#{@user.name}のデータを削除しました。"
    redirect_to users_url
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
