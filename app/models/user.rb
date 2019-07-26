class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  acts_as_messageable


  has_many :invitations, class_name: self.to_s, as: :invited_by
  validates :first_name, :last_name, presence: true
  #Returning any kind of identification you want for the model
  def name
    self.first_name.to_s + " " + self.last_name.to_s + "(" + self.email.to_s + ")"
  end

  #Returning the email address of the model if an email should be sent for this object (Message or Notification).
  #If no mail has to be sent, return nil.
  def mailboxer_email(object)
    #Check if an email should be sent for that object
    #if true
    self.email
    #if false
    #return nil
  end

  def invite_accepted?
    invitation_accepted_at != nil
  end

  # instead of deleting, indicate the user requested a delete & timestamp it  
  def soft_delete
    update_attribute(:deleted_at, Time.current)
  end
  
  # ensure user account is active  
  def active_for_authentication?
    super && !deleted_at && !disabled
  end
  
  # provide a custom message for a deleted account
  def inactive_message
    if deleted_at
      :deleted_account
    elsif disabled
      :disabled_account
    else
      super
    end
  end
end
