# frozen_string_literal: true

# helper
module MailHelper
  def send_mail_confirmation_instructions(user)
    DeviseMailer.with(object: user).confirmation_instructions.deliver_later
  end

  def send_mail_activated(user)
    DeviseMailer.with(object: user).activated_email.deliver_later
  end

  def send_mail_instruction(user)
    DeviseMailer.with(object: user).reset_password_instructions.deliver_later
  end

  def send_mail_password_changed(user)
    DeviseMailer.with(object: user).password_change.deliver_later
  end
end
