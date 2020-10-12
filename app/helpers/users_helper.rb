module UsersHelper
  
  def reminder_month
    Post.find(1).reminder_month
  end
  
  def reminder_consignments
    @user_consignments.each do
      @reminder = @user_consignments.where("ship_date < ?", Date.current - reminder_month.month)
    end
    @reminder
  end
end
