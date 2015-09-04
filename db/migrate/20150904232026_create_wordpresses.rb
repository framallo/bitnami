class CreateWordpresses < ActiveRecord::Migration
  def change
    create_table :wordpresses do |t|
      t.string :instance_id
      t.references :user, index: true, foreign_key: true
      t.string :status

      t.timestamps null: false
    end
    add_index :wordpresses, :instance_id, unique: true
  end
end
