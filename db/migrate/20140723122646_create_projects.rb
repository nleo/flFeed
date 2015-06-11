class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      # t.id :serial
      t.integer :remote_id
      t.integer :site, size: 1
      t.string :title
      t.text :body
      t.string :uri, null: false
      t.string :category
      t.string :budget_origin
      t.integer :budget_amount
      t.string :budget_currency, size: 3
      t.timestamp :published
      t.timestamp :viewed_at

      t.timestamps
    end
  end
end
