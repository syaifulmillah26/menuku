# frozen_string_literal: true

# User
class User < ApplicationRecord
  include StateMachines::User
  include ApplicationHelper
  include MailHelper

  acts_as_paranoid

  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable, :timeoutable,
          :trackable and :omniauthable
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  alias_method :authenticate, :valid_password?
  # extend FriendlyId
  # friendly_id :uuid, use: :slugged
  rolify

  belongs_to  :company,
              class_name: 'Admin::Company',
              optional: true

  belongs_to  :outlet,
              class_name: 'Admin::Outlet',
              optional: true

  has_one     :user_detail,
              class_name: 'UserDetail',
              dependent: :destroy,
              inverse_of: :user

  accepts_nested_attributes_for :user_detail,
                                update_only: true,
                                allow_destroy: true

  validates_uniqueness_of :email

  def self.create_user_provider(data, provider)
    where(email: data['email']).first_or_initialize.tap do |user|
      user.provider = provider
      user.email = data['email']
      user.password = Devise.friendly_token[0, 20]
      user.password_confirmation = user.password
      user.save!
    end
  end
end
