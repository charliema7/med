class ChangeIpColumnType < ActiveRecord::Migration[5.2]
  def change
    change_column :login_activities, :ip, :string
  end
end
