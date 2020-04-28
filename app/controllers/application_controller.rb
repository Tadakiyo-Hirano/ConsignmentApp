class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  # 新規登録時(sign_up時)にnameキーのパラメーターを追加で許可
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:code, :name])
  end
  
  # ログイン後の画面遷移
  def after_sign_in_path_for(resource)
    user_path(current_user)
  end
  
  # ログアウト後の画面遷移
  def after_sign_out_path_for(resource)
    root_path
  end
  
  # フレンドリーフォワーディング
  def after_sign_in_path_for(resource)
    if (session[:user_return_to] == root_path)
      super
    else
      session[:user_return_to] || root_path
    end
  end
  
  # ログインしていない場合はroot_urlにリダイレクト
  def signed_in_user
    unless user_signed_in?
      store_current_location
      flash[:alert] = "ログインしてください。"
      redirect_to root_path
    end
  end
  
  def set_user
    @user = User.find(params[:id])
  end
  
  # before_action :authenticate_user! コントローラーに設定して、ログイン済ユーザーのみにアクセスを許可する
  # user_signed_in? ユーザーがサインイン済かどうかを判定する
  # current_user サインインしているユーザーを取得する
  # user_session ユーザーのセッション情報にアクセスする
end
