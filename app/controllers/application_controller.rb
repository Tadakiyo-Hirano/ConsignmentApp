class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  # 新規登録時(sign_up時)にnameキーのパラメーターを追加で許可
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
  
  # ログイン後の画面遷移
  def after_sign_in_path_for(resource)
    root_path
  end
  
  # ログアウト後の画面遷移
  def after_sign_out_path_for(resource)
    root_path
  end
end
