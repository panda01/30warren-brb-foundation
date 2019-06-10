class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.integer :floor
      t.string :letter

      t.timestamps null: false
    end
  end
end
