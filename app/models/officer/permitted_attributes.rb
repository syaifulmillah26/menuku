# frozen_string_literal: true

module Officer
  # Officer::PermittedAttributes contains the attributes permitted through strong
  # params in various controllers in the frontend. Extensions and stores that
  # need additional params to be accepted can mutate these arrays to add them.
  module PermittedAttributes
    ATTRIBUTES = [
      :address_attributes,
      :user_attributes,
      :user_detail_attributes,
      :role_attributes,
      :user_role_attributes,
      :order_attributes,
      :line_item_attributes
    ]

    mattr_reader(*ATTRIBUTES)

    @@address_attributes = [
      :address1, :address2,
      :zipcode, :alternative_phone,
      :fb_url, :ig_url, :tw_url, :web_url,
      :province_id, :city_id, :subdistrict_id
    ]

    @@user_detail_attributes = [
      :id, :user_id, :fullname, address_attributes: address_attributes
    ]

    @@user_attributes = [
      :id, :name, :email, :password, :password_confirmation, :slug,
      user_detail_attributes: user_detail_attributes
    ]

    @@role_attributes = %i[id name]

    @@user_role_attributes = %i[user_id role_id]

    @@order_attributes = [
      :item_count, :item_total, :total, :tax_and_service,
      :promo_total, :outlet_id, :table_id, :payment_preference
    ]

    @@line_item_attributes = [
      :product_id, :order_id, :quantity, :outlet_id
    ]

    # @@address_book_attributes = address_attributes + [:default]
  end
end
