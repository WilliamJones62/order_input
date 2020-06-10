json.array! @fs_orders do |o|
  json.rep o.rep_name
  json.customer o.customer
  json.shipto o.shipto
  json.created_at o.created_at.strftime("%l:%M:%S%p")
  json.date_required o.date_required.strftime("%m/%d/%Y")
  json.cut_off o.cut_off
end
