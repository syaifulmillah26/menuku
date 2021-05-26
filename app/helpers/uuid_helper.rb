# frozen_string_literal: true

# Uuid helper is for generating uuid for every object that has uuid attribute
module UuidHelper
  def self.included(base)
    return if base.name.blank?

    base.primary_key = 'uuid'
    base.before_create :assign_uuid
  end

  private

  def assign_uuid
    self.uuid = generate_uuid
  end

  def generate_uuid
    @uuid = SecureRandom.hex(15)
    return @uuid unless check_uuid.present?

    generate_uuid
  end
end
