class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.text :members
      t.belongs_to :user
      t.timestamps
    end
  end
end
