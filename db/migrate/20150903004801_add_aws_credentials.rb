class AddAwsCredentials < ActiveRecord::Migration
  def change
    add_column :users, :encrypted_aws_access_key_id, :string
    add_column :users, :encrypted_aws_access_key_id_salt, :string
    add_column :users, :encrypted_aws_access_key_id_iv, :string
    add_column :users, :encrypted_aws_secret_access_key, :string
    add_column :users, :encrypted_aws_secret_access_key_salt, :string
    add_column :users, :encrypted_aws_secret_access_key_iv, :string
  end
end
