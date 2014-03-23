namespace :create do
  desc '任意名でクライアントを作成する．filename='
  task :option => "chasers/#{ENV['filename']}.rb"

  desc 'デフォルト名でクライアントを作成する．'
  task :default => 'chasers/my_client.rb'
end

file "chasers/#{ENV['filename']}.rb" => ['chasers/template.rb'] do
  client_rb = File.read('chasers/template.rb')

  open("chasers/#{ENV['filename']}.rb", 'w') do |f|
    f.write client_rb.gsub('{Hoge}', ENV['filename'].capitalize)
  end
  puts "chasers/#{ENV['filename']}.rb を作成"
end

file "chasers/my_client.rb" => ['chasers/template.rb'] do
  client_rb = File.read('chasers/template.rb')

  open('chasers/my_client.rb', 'w') do |f|
    f.write client_rb.gsub('{Hoge}', "Hoge")
  end
  puts "chasers/my_client.rb を作成"
end
