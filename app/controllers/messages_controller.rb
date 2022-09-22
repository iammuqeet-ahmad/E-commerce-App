class MessagesController < ApplicationController
  
  def success_msg
    session[:cart] = []
    flash[:notice] = "Order successfull"
    redirect_to root_path
  end

  def cancle_msg
    flash[:alert] = "Order unsuccessful"
    redirect_to root_path
  end
end
