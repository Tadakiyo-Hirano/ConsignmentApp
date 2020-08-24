require 'csv'

CSV.generate do |csv|
  column_names = %w(code name)
  csv << column_names
  @export_customers.each do |customer|
    column_values = [
      customer.code,
      customer.name,
    ]
    csv << column_values
  end
end
