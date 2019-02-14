task :orders => :environment do
  # find all orders with stutus 'created', load them into a CSV file, export the file, and set the orders status to 'processed'
  FsOrder.to_txt
end
