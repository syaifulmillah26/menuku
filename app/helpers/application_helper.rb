# frozen_string_literal: true

# ApplicationHelper
module ApplicationHelper
  def secure_random_token
    SecureRandom.hex(40)
  end

  def current_time
    DateTime.now
  end

  private

  def set_slug
    object.slug = dasherize_name
  end

  def dasherize_name
    object.name.gsub(' ', '-')
  end

  def object
    self
  end
end
