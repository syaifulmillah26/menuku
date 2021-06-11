# frozen_string_literal: true

# User
class User < ApplicationRecord
  include StateMachines::User
  include ApplicationHelper
  include UuidHelper

  acts_as_paranoid

  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable, :timeoutable,
          :trackable and :omniauthable
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  alias_method :authenticate, :valid_password?
  extend FriendlyId
  friendly_id :uuid, use: :slugged
  rolify

  belongs_to  :company,
              class_name: 'Admin::Company',
              foreign_key: :company_id,
              primary_key: :uuid,
              optional: true

  belongs_to  :outlet,
              class_name: 'Admin::Outlet',
              foreign_key: :outlet_id,
              primary_key: :uuid,
              optional: true,
              dependent: :destroy

  has_one     :user_detail,
              class_name: 'UserDetail',
              foreign_key: :user_id,
              primary_key: :uuid,
              dependent: :destroy,
              inverse_of: :user

  has_one     :address, through: :user_detail

  after_create :assign_default_role
  after_create :send_email_confirmation

  accepts_nested_attributes_for :user_detail

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

  private

  def check_uuid
    User.where(uuid: @uuid)
  end

  def send_email_confirmation
    return object.confirm! if company_or_provider_exist

    update_column(:confirmation_token, secure_random_token)
    update_column(:confirmation_sent_at, current_time)
    DeviseMailer.with(object: object).confirmation_instructions.deliver_later
  end

  def assign_default_role
    object.add_role(:admin) if object.roles.blank?
  end

  def update_confirmed_at
    update_column(:confirmed_at, current_time)
  end

  def company_or_provider_exist
    return true if object.company_id.present? || object.provider.present?

    false
  end
end
