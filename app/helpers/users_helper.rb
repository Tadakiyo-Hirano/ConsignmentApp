module UsersHelper
  
  def reminder_consignments
    month = Post.find(1).reminder_month.month
    @user_consignments.each do |c|
     @aaa = Consignment.where("ship_date < ?", Date.current - month)
    end
    @aaa
  end
end
