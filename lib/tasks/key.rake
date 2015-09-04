namespace :key do
  desc 'create an encription key'
  task :create do
    cipher = OpenSSL::Cipher.new('aes-128-cbc').random_key
    puts Base64.encode64(cipher)
  end
end
