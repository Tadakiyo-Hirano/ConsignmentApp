class ApplicationController < ActionController::Base
  include ApplicationHelper
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  # 新規登録時(sign_up時)にnameキーのパラメーターを追加で許可
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:code, :name])
  end
  
  # フレンドリーフォワーディング
  def after_sign_in_path_for(resource)
    if (session[:user_return_to] == root_path)
      super
    else
      session[:user_return_to] || root_path
    end
  end
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def set_product
    @product = Product.find(params[:id])
  end
  
  def set_customer
    @customer = Customer.find(params[:id])
  end
  
  private
  
    # ログインしていない場合はroot_urlにリダイレクト
    def signed_in_user
      unless user_signed_in? || admin_signed_in?
        store_current_location
        flash[:alert] = "ログインしてください。"
        redirect_to root_url
      end
    end
    
    # 他ユーザーのpathにアクセスした場合は自分のメインページにリダイレクト
    def signed_in_correct_user
      unless current_user.id == @user.id
        flash[:alert] = "アクセス権限がありません。"
        redirect_to user_url(current_user)
      end
    end
    
    # adminでない場合はroot_urlにリダイレクト
    def signed_in_admin
      unless admin_signed_in?
        store_current_location
        flash[:alert] = "アクセス権限がありません。"
        redirect_to root_url
      end
    end
  
    # フレンドリーフォワーディング用、アクセスされたURLを保存する
    def store_current_location
      store_location_for(:user, request.url)
    end
    
    # ログイン後のリダイレクト先 userとadminでリダイレクト先分岐
    def after_sign_in_path_for(resource_or_scope)
      if resource_or_scope.is_a?(Admin)
        admin_url(current_admin)
      else
        user_url(current_user)
      end
    end
    
    # ログアウト後のリダイレクト先
    def after_sign_out_path_for(resource_or_scope)
      if resource_or_scope == :admin
        admin_session_url
      else
        root_url
      end
    end
  
  # before_action :authenticate_user! コントローラーに設定して、ログイン済ユーザーのみにアクセスを許可する
  # user_signed_in? ユーザーがサインイン済かどうかを判定する
  # current_user サインインしているユーザーを取得する
  # user_session ユーザーのセッション情報にアクセスする
end
