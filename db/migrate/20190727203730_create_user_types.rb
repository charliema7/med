class CreateUserTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :user_types, id: :uuid do |t|
      t.string :name

      t.timestamps
    end
    add_index :user_types, :name, unique: true
  end
end
