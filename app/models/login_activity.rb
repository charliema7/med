class LoginActivity < ApplicationRecord
  belongs_to :user, polymorphic: true, optional: true
  before_create :set_browser_name

  private
    def set_browser_name
      browser = Browser.new(self.user_agent)
      self.browser_name = browser.name
      self.browser_version = browser.version
      self.device_name = browser.device.name
      self.platform_name = browser.platform.name
      self.platform_version = browser.platform.version
    end 
end
