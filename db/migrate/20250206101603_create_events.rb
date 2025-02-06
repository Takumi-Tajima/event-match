class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.datetime :date, null: false
      t.datetime :start_time
      t.datetime :end_time
      t.string :url
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
