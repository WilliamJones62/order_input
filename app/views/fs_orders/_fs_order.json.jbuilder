json.extract! fs_order, :id, :partcode, :qty, :customer, :shipto, :date_required, :created_at, :updated_at
json.url fs_order_url(fs_order, format: :json)
