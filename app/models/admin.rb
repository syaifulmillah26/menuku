# frozen_string_literal: true

# Admin Database
class Admin < ActiveRecord::Base
  self.abstract_class = true
  establish_connection(Rails.env.test? ? :admin_test : :admin)
end
