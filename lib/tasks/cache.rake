namespace :cache do
  desc "Deleting Rails cache"
  task :delete do
    Rails.cache.delete("719978allcusts")
  end
end
