class AddUserTypeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :user_type, foreign_key: true, type: :uuid
  end
end
