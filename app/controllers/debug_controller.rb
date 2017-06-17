class DebugController < ApplicationController
  # POST /carts/update_session
  def update_session
    new_cart_id = params[:cart_id]
    if Cart.find(new_cart_id)
      logger.warn "Updating cart_id from #{session[:cart_id]} to: #{params[:cart_id]}."
      session[:cart_id] = params[:cart_id]
      logger.warn "cart_id is now: #{session[:cart_id]}."
      redirect_to store_index_url, notice: "Cart ID updated to #{session[:cart_id]}"
    else
      logger.warn "Couldn't load cart_id: #{new_cart_id}."
      redirect_to store_index_url, notice: "Couldn't load cart_id: #{new_cart_id}."
    end
  end
end
