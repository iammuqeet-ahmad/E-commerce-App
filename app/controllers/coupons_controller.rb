# frozen_string_literal: true

# This is Coupon controller
class CouponsController < ApplicationController
  require 'date'
  def coupon_check
    if Coupon.any?
      if @coupon = Coupon.find_by(name: params[:$promo])
        if Time.zone.today <= @coupon.expiry_date
          $val = @coupon.discount
          flash[:success] = 'Discount Applied Successfully!'
        else
          flash[:alert] = 'Coupon is Expired'
        end
      else
        flash[:alert] = 'The Coupon you entered in incorrect'
      end
    else
      flash[:alert] = 'Currently no Coupon in available'
    end
    redirect_to carts_path
  end
end
