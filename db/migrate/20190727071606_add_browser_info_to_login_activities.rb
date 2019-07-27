class AddBrowserInfoToLoginActivities < ActiveRecord::Migration[5.2]
  def change
    add_column :login_activities, :browser_name, :string
    add_column :login_activities, :browser_version, :string
    add_column :login_activities, :device_name, :string
    add_column :login_activities, :platform_name, :string
    add_column :login_activities, :platform_version, :string
  end
end
