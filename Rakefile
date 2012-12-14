# encoding: utf-8
require "ca"
task :default => [:csv_generator]

desc "Mini csv generator"
task :csv_generator do
  puts "----------------------------------"
  puts "   Welcome to CSV Generator       "
  puts "----------------------------------\n"
  puts "Choose one option:\n1. generate from default (fixtures/seo_text.html) | csv_default"
  puts "2. generate from external server | csv_external"
  puts "3. generate from file in root folder | csv_file"
  choice = STDIN.gets.split("\n").join
  case choice
    when "1" then Rake::Task[:csv_default].invoke
    when "2" then Rake::Task[:csv_external].invoke
    when "3" then Rake::Task[:csv_file].invoke
    else puts "Wrong choice, run rake again"
  end
end

desc "Create csv file from default file"
task :csv_default do
  puts "Wait..."
  analyse = Ca::Analyse.new(HTMLReader.instance.fixtures("seo_text"));
  analyse.description.to_csv("default")
  puts "Bye bye.."
end

desc "Create csv file from external server URL"
task :csv_external do
  puts "Please write page URL here: "
  url = STDIN.gets.split("\n").join
  puts "Wait..."
  analyse = Ca::Analyse.new(HTMLReader.instance.page(url));
  analyse.description.to_csv("external")
  puts "Bye bye.."
end

desc "Create csv file from internal file"
task :csv_file do
  puts "Please write page PATH here: "
  path = STDIN.gets.split("\n").join
  puts "Wait..."
  analyse = Ca::Analyse.new(HTMLReader.instance.page(path));
  analyse.description.to_csv("internal")
  puts "Bye bye.."
end