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

  def generated_number
    "#{current_time.strftime('%y%m%d')}000"
  end

  def model_class
    object.class
  end

  def check_generated_number(code, number, field, index)
    number = number.to_i + index
    result = code + number.to_s
    exist = model_class.where(field.to_sym => result)&.first
    return check_generated_number(code, number, field, index + 1) if exist

    result
  end
end
