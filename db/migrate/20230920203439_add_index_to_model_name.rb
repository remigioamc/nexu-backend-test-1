class AddIndexToModelName < ActiveRecord::Migration[7.0]
  def change
    add_index :models, :name, unique: true
  end
end
