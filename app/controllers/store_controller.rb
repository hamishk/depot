class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart
  def index
    @products = Product.order(:title)

    # log the visit to the index
    if session[:index_visit_count].nil?
      session[:index_visit_count] = 1
    else
      session[:index_visit_count] += 1
    end
  end
end
