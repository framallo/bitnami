class InstanceStatus < ActiveRecord::Migration
  def change
    create_table :instance_statuses do |t|
      t.column :wordpress_id, :integer
      t.column :system_status, :string
      t.column :instance_status, :string
      t.column :state_name, :string
      t.column :state_code, :integer
    end
  end
end
