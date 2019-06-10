class CreateBuyers < ActiveRecord::Migration
  def change
    create_table :buyers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :slug
      t.text :data
      t.text :message

      t.timestamps null: false
    end
  end
end
