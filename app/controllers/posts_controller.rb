class PostsController < ApplicationController
  before_action :set_post
  before_action :authenticate_admin!
  
  def show
  end
  
  def edit
  end
  
  def update
    if @post.update_attributes(post_params)
      flash[:notice] = "通知設定を更新しました。"
      redirect_to admin_url
    else
      flash.now[:alert] = "更新に失敗しました。<br>" + @post.errors.full_messages.join("<br>")
      render :edit
    end
  end
  
  private
   
   def set_post
     @post = Post.find(params[:id])
   end
   
   def post_params
      params.require(:post).permit(:month_day, :month_notice, :month_check, :year_month, :year_day, :year_notice, :year_check)
   end
end
