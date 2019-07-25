class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  acts_as_messageable


  has_many :invitations, class_name: self.to_s, as: :invited_by

  #Returning any kind of identification you want for the model
  def name
    self.email
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
end
