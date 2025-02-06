class AddCheckedToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :checked, :boolean, default: false, null: false
  end
end
