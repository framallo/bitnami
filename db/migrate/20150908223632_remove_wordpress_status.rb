class RemoveWordpressStatus < ActiveRecord::Migration
  def change
    remove_column :wordpresses, :status
  end
end
