class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_encrypted :aws_access_key_id,
                 key: ENV['ENCRYPTION_KEY'],
                 mode: :per_attribute_iv_and_salt
  attr_encrypted :aws_secret_access_key,
                 key: ENV['ENCRYPTION_KEY'],
                 mode: :per_attribute_iv_and_salt
end
