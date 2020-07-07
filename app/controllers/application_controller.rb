class ApplicationController < ActionController::Base
  include ApplicationHelper
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  # PCA-Web API
  def pca_api
    # require "uri"
    # require "net/http"
    
    # url = URI("https://east02.pcawebapi.jp/v1/Kon20/Hello")
    
    # https = Net::HTTP.new(url.host, url.port);
    # https.use_ssl = true
    
    # request = Net::HTTP::Get.new(url)
    
    # response = https.request(request)
    
    # @api_info = response.read_body
    
    require "uri"
    require "net/http"
    
    url = URI("https://east02.pcawebapi.jp/v1/Kon20/GetLogOnUser")
    
    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true
    
    request = Net::HTTP::Get.new(url)
    request["Authorization"] = "Bearer qnGDr-S030RtHXWZZgquJkCXnVvO22pXNmhNhcmRemxNDPqOedkYkkLB05ZagT1aiiolRvopzf1AFQRkTrWcKbtvp0vNP_PIgH5UBAQ7gvnX7af7BHzE5GyxOMZhUuG1ZvRVB3C1LkqVh0-0gNtY3Let1FsKGeWGsbs8rA0VJa3ntcVZNzIp0krqbEGH7XwPSpf-kb3ZhyJPFGgTRzhA_pmGQctQuKPllwg6wqWquLnKmXxiZGerTjC0BB--eumLYsAdXsbLjw5U-vsuhEngRWVUiqSYt9LNgbnXbI9n7X-xf2KuNzVwepvAm7HTkgyHOunMerLmelgkznN0yoJ9hdZXxjGISYMkrhoQIyNzlNoWCvyoGuxo6IQ3aiHbxKFWuDzFA4KlR8XzmehBB1dDOCpxqMNosR5lvpHocRpQrs0wI44EERHGk4da3hpDyxyKd47lOfzxDAjcA_KRb_D3TsIAty2Z1yRrsflqnqQDUgtD6xXL0BMjnPVNMC98__Zo_gFN6IUfaatuYv5fsu5EL0WDSFVvXC4JOyh2aKsqqYWWwNVIyjuv7ITuLMan27KEy2BzKLWyyz_w9i259RQ-tpyO7-rGsy3-Gqu1TWxIQSMCmglTigCdHmnhv55B7915bHeVXnsfsgtjNAgjqLEJGwpNk8k"
    request["Accept"] = ""
    request["Cookie"] = "__RequestVerificationToken_L3YxL0tvbjIw0=4V2JGMlaK6nAfEM8GV-FleAiuyDFB1BPI2cHuF0uoU8QdeksyDMeWjd98TeiBsHiyt1o11jgxwNl5elC1edSBfnGl-Q1"
    
    response = https.request(request)
    @api_info = response.read_body

  end
  
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
