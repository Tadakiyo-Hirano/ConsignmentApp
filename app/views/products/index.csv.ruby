require 'csv'

CSV.generate do |csv|
  column_names = %w(code name)
  csv << column_names
  @export_products.each do |product|
    column_values = [
      product.code,
      product.name
    ]
    csv << column_values
  end
end
