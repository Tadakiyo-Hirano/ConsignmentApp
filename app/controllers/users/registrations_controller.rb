# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: %i(update)

  # GET /resource/sign_up
  def new
    unless admin_signed_in?
      redirect_to root_url
    else
      super
    end
  end

  # POST /resource
  def create
    unless admin_signed_in?
      redirect_to root_url
    else
      # super
      build_resource(sign_up_params)

      resource.save
      yield resource if block_given?
      if resource.persisted?
        if resource.active_for_authentication?
          flash[:notice] = "#{@user.name}さんのアカウントを登録しました。"
          # set_flash_message! :notice, :signed_up
          redirect_to users_url
          # sign_up(resource_name, resource)
          # respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # ユーザー情報更新
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:code, :name])
  end
  
  # パスワードの入力なしでユーザー情報更新
  # update_without_current_passwordはuser.rbに記述
  def update_resource(resource, params)
    resource.update_without_current_password(params)
  end
  
  # ユーザー更新後のリダイレクト先
  def after_update_path_for(resource)
    user_path(current_user)
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
