class AddHelpedByToBuyer < ActiveRecord::Migration
  def change
    add_column :buyers, :helped_by, :string
  end
end
