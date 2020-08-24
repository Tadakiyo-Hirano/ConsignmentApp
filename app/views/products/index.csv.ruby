require 'csv'

CSV.generate do |csv|
  column_names = %w(code name classification category)
  csv << column_names
  @export_products.each do |product|
    column_values = [
      product.code,
      product.name,
      product.classification,
      product.category
    ]
    csv << column_values
  end
end
