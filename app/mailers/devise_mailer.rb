class DeviseMailer < Devise::Mailer
  default template_path: 'devise/mailer'
  default from: 'info@menuku.com'

  def company_instructions
    mail(to: object.email, subject: "Company Instructions")
  end

  def confirmation_instructions
    mail(to: object.email, subject: "Email Confirmation Instructions")
  end

  def activated_email
    mail(to: object.email, subject: "Email Activated")
  end

  def reset_password_instructions
    mail(to: object.email, subject: "Reset Password Instructions")
  end

  def email_changed
    mail(to: object.email, subject: "Email Changed")
  end

  def password_change
    mail(to: object.email, subject: "Password Changed")
  end


  protected
  def object
    @object  = params[:object]
  end



end