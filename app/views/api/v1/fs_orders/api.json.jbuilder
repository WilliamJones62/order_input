json.array! @fs_orders do |o|
  json.customer o.customer
  json.shipto o.shipto
  json.rep o.rep
end
