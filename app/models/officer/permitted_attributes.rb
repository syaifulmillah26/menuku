# frozen_string_literal: true

module Officer
  # Officer::PermittedAttributes contains the attributes permitted through strong
  # params in various controllers in the frontend. Extensions and stores that
  # need additional params to be accepted can mutate these arrays to add them.
  module PermittedAttributes
    ATTRIBUTES = [
      :address_attributes,
      :company_attributes,
      :company_detail_attributes,
      :user_attributes,
      :user_detail_attributes,
      :role_attributes,
      :user_role_attributes
    ]

    mattr_reader(*ATTRIBUTES)

    @@company_attributes = [
      :id, :registration_id, :company_name,
      users_attributes: [
        :id, :email, :password, :password_confirmation
      ],
      company_detail_attributes: [
        :id, :company_id, :address_id, :npwp,
        address_attributes: [
          :address1, :address2,
          :zipcode, :phone, :alternative_phone,
          :fb_url, :ig_url, :tw_url, :web_url,
          :province_id, :city_id, :subdistrict_id
        ]
      ],
      outlets_attributes: [
        :id, :name,
        address_attributes: [
          :address1, :address2,
          :zipcode, :phone, :alternative_phone,
          :fb_url, :ig_url, :tw_url, :web_url,
          :province_id, :city_id, :subdistrict_id
        ]
      ]
    ]

    @@company_detail_attributes = [
      :id, :company_id, :address_id
    ]

    @@address_attributes = [
      :address1, :address2,
      :zipcode, :alternative_phone,
      :fb_url, :ig_url, :tw_url, :web_url,
      :province_id, :city_id, :subdistrict_id
    ]

    @@user_attributes = [
      :id, :name, :uuid, :email, :password, :password_confirmation, :slug,
      user_detail_attributes: [:user_id, :firstname, :lastname, :address1, :address2,
        :zipcode, :alternative_phone,
        :province_id, :city_id, :subdistrict_id]
    ]

    @@user_detail_attributes = [
      :id, :user_id, :firstname, :lastname, address_attributes: [
        :address1, :address2,
        :zipcode, :alternative_phone,
        :province_id, :city_id, :subdistrict_id
      ]
    ]

    @@role_attributes = [ :id, :name ]

    @@user_role_attributes = [ :user_id, :role_id ]

    # @@address_book_attributes = address_attributes + [:default]
  end
end
