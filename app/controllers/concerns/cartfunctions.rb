# frozen_string_literal: true

# this is concern for carts_controller
module Cartfunctions
  include ActiveSupport::Concern

  def coupon_check
    coupons = { 'DEVS1NC' => 0.3, 'PAKARMY' => 0.5, 'AZADI' => 0.7 }
    if coupons[params['$promo']]
      validity = { 'day' => 25, 'month' => 9, 'year' => 2022 }
      time = Time.zone.now
      if time.year <= validity['year'] && time.month <= validity['month'] && time.day <= validity['day']
        $val = coupons[params['$promo']]
        flash[:success] = 'Discount Applied Successfully!'
      else
        flash[:alert] = 'Coupon is Expired'
      end
    else
      flash[:alert] = 'Invalid coupon'
    end
    redirect_to carts_path
  end
end
