class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :title
      t.string :url
      t.string :thumbnail
      t.string :category

      t.timestamps null: false
    end
  end
end
