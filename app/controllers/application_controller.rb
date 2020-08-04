class ApplicationController < ActionController::Base
  include ApplicationHelper
  include UsersHelper
  include CustomersHelper
  include ProductsHelper
  include ConsignmentsHelper
  include StocksHelper
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  # PCA-Web API
  def pca_api
    require "uri"
    require "net/http"
    
    # url = URI("https://east02.pcawebapi.jp/v1/Kon20/Hello")
    
    # https = Net::HTTP.new(url.host, url.port);
    # https.use_ssl = true
    
    # request = Net::HTTP::Get.new(url)
    
    # response = https.request(request)
    
    # @api_info = response.read_body


    # url = URI("https://east02.pcawebapi.jp/v1/Kon20/FindDataArea")
    
    # https = Net::HTTP.new(url.host, url.port);
    # https.use_ssl = true
    
    # request = Net::HTTP::Post.new(url)
    # request["Authorization"] = "Bearer s9iZmAy6-XUCtZMDM855ZpvpeEfBGifUl8I2EGbaKoZo5UQN8meriSj9pWWjCDslcUjebF_Vs2l42-Ywy11gUGiU13WSjOA5Eh5UIPsSQUIEPf2z7JC1fEVs8JsFXXDz5fIQXMeLtzH6VF7K6KMOO9OWGKGt7S4WYrwZWOSPoWP5_paQnIHz9xEI2KwwR_WpmeBMjET66GL8P8r5A7GyL7kwkl8HfJAVzkqm_LvXS0mS7DCoya1RpHZTwSB4dGuuqHT5xMb8Krz-ekPjueqACrGf4z8S7srBlZwfaZ0_K1e2mTKSKuHBbE1d6m_dMe9kfqYUXtA-P174aVYb190IMvObDvAOv1C6JL6riSbFPjs3Jalt-8iUQdRvj_nTJrisSjhNl5sRY3BzJA4xjUhd5hbrd5OvqyGLBZoUAx-9H22uQj_AbXt1hvo7L0w5hlGTwLbNBF-V2f7NfPHMNKCP0y3E-lLiFFsj7bPyyUTMMGewd_KRUVXuXm2aFfL-mHXQuJcuSm35Pj7FxGCmYJAxw6LJhpe2DZsqMcWyMtlJezEhBGMEeI4-YLPUqFx-PADAnhlsoXMF_tTlqUDBt0bTlBD7kpo9sOK1XdrrBUeaCTiI2b3d5Q9SAB5gfy6IM-uy1M7HsNbBzzUGGd9NnRkfI9CAjB0"
    # request["Accept"] = ""
    # # request["Cookie"] = "__RequestVerificationToken_L3YxL0tvbjIw0=cgtZRdbCslibwLmEygm6Z-MhYbewmhqwEwR11e8Qrj3uWlJhW4P67h7CDt_MeKH6kNoxVrKMTf9fzdVLAgEYxnJeKv81"
    
    # response = https.request(request)
    
    
    
    # require "uri"
    # require "net/http"
    
    # url = URI("https://east02.pcawebapi.jp/v1/Kon20/GetLogOnDataArea")
    
    # https = Net::HTTP.new(url.host, url.port);
    # https.use_ssl = true
    
    # request = Net::HTTP::Get.new(url)
    # request["Authorization"] = "Bearer Hhu7IJtg3Q3BCxi1sIbTI921CItZ2oFJHhtCprrns1hMo_hTzvHGyOZbFXvufRn2J7WQx0JyB0fkPWoiftRaScBUXjmTEBASQGp6XizeYh1e0VTRw1KxumQ069xie3mp1SL8vvFXyDJ4i2_GUfic13FQcqGPr7_K47QvE4wNQ6ZvF92DnUboahDXNg9OPesVlDm5Tk0Sc6SjF7GHpU4lBltLY_Qzoox0qVVFOYN1MeMWG7bLJuh0cUOa89EZZvLveN3kxtCDCPq_83S2yLs30CDMQ2RlbW2CIlOZE1n15xcBBxzrCD8WiywYHtJ65F3nAMhOYKnzs1XvcwgYTfy-a7ND7g6vQVKgTJVZ0DZbxADePHmCxwgr-ebqL08oBp-0b-0pHewEvSW8zZE4DG3NvtRLkx9dUbEwCsxu5baHGpeHKdRuZVuyp8ZiYssoHGujdYW59zMlMjd1G_WM1_8HwsbYNG5xdapiUIIqCWN0_63IgKPcPzRRYhoghoKOWIBEM1vhvmTnEFNJDnwngsM_2FCQNeRn5Q9TrSey99BCfvom3rd_jbJ0slQRijKH26sZd7Ses8YcJ0qg_bCoxK1M7St-XKd08QeUXETDHjhyTQVUueXpXjMc0_dZlOE-faPrfzLNYKd5_Gevo4XvqNKpo3xANeo"
    # request["Accept"] = ""
    
    # response = https.request(request)
    
    require "uri"
    require "net/http"
    
    url = URI("https://east02.pcawebapi.jp/v1/Kon20/Auth/PreAuthorize")
    
    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true
    
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    # request["Cookie"] = "830213468add4043a3ff89c1b03595f3=573840572c0b4d348961be1924d2f0f7; __RequestVerificationToken_L3YxL0tvbjIw0=zkcQxXpC2cH5Uq4aHjIjUgpPF_BVWNshRVRP6hI8phvhBwIPwefgCrDwLaEeF4kPvBHTEAnNc5mGBqa9zGdPeH7DKcU1"
    request.body = "{\n\t\"client_id\":\"830213468add4043a3ff89c1b03595f3\",\n\t\"service_id\":\"29657425\",\n\t\"service_password\":\"bG5PSyc4\",\n\t\"username\":\"mac-k\",\n\t\"password\":\"mac+8880\"\n}"
    
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
