class CreateLoginActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :login_activities, id: :uuid do |t|
      t.string :scope
      t.string :strategy
      t.string :identity
      t.boolean :success
      t.string :failure_reason
      t.references :user, polymorphic: true, type: :uuid
      t.string :context
      t.inet :ip
      t.text :user_agent
      t.text :referrer
      t.string :city
      t.string :region
      t.string :country
      t.float :latitude
      t.float :longitude
      t.datetime :created_at
    end

    add_index :login_activities, :identity
    add_index :login_activities, :ip
  end
end
