class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :name, null: false, default: ''
      t.string :description, null: false, default: ''
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.string :image, null: false, default: ''
      t.string :url, null: false, default: ''
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
