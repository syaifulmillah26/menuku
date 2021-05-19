# frozen_string_literal: true

# User
class User < ApplicationRecord
  include StateMachines::User

  acts_as_paranoid

  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable, :timeoutable,
          :trackable and :omniauthable
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  alias_method :authenticate, :valid_password?
  extend FriendlyId
  friendly_id :uuid, use: :slugged
  rolify

  has_one :user_detail,
          class_name: 'UserDetail',
          dependent: :destroy,
          inverse_of: :user

  has_one :address, through: :user_detail

  belongs_to  :company,
              class_name: 'Admin::Company'


  after_create :assign_default_role
  after_create :assign_default_user_detail
  after_create :send_email_confirmation
  after_create :generate_uuid

  private

  def generate_uuid
    update_column(:uuid, SecureRandom.hex(30))
  end

  def send_email_confirmation
    update_column(:confirmation_token, SecureRandom.hex(50))
    update_column(:confirmation_sent_at, DateTime.now)
    DeviseMailer.with(object: user).confirmation_instructions.deliver_later
  end

  def assign_default_role
    user.add_role(:user) if user.roles.blank?
  end

  def assign_default_user_detail
    address = Admin::Address.create(address1: nil)
    UserDetail.create(user_id: user.id, address_id: address.id)
  end

  def user
    self
  end

  def update_confirmed_at
    update_column(:confirmed_at, DateTime.now)
  end
end
