require 'csv'

def import(file_path, model)
  CSV.foreach(file_path, headers: true) do |row|
    model.create!(row.to_hash)
  end
end

namespace :csv_load do 
  task :merchants => [:environment] do 
    file_path = Rails.root.join('db/data/merchants.csv')
    CSV.foreach(file_path, headers: true) do |row|
      Merchant.create!(row.to_hash)
    end
  end

  task :customers => [:environment] do 
    file_path = "db/data/customers.csv"
    CSV.foreach(file_path, headers: true) do |row|
      Customer.create!(row.to_hash)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('customers')
  end

  task :items => [:environment] do 
    file_path = "db/data/items.csv"
    CSV.foreach(file_path, headers: true) do |row|
      Item.create!(row.to_hash)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('items')
  end

  task :invoices => [:environment] do 
    file_path = "db/data/invoices.csv"
    CSV.foreach(file_path, headers: true) do |row|
      Invoice.create!(row.to_hash)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('invoices')
  end

  task :transactions => [:environment] do 
    file_path = "db/data/transactions.csv"
    CSV.foreach(file_path, headers: true) do |row|
      Transaction.create!(row.to_hash)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('transactions')
  end

  task :invoice_items => [:environment] do 
    file_path = "db/data/invoice_items.csv"
    CSV.foreach(file_path, headers: true) do |row|
      InvoiceItem.create!(row.to_hash)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')
  end

  task :all => [:environment] do
    tables = ["merchants", "customers", "items", "invoices", "transactions", "invoice_items"]

    tables.each do |table|
      Rake::Task["csv_load:#{table}"].invoke
      ActiveRecord::Base.connection.reset_pk_sequence!("#{table}")
    end

  end
end

desc 'Resets Postgres auto-increment ID column sequences to fix duplicate ID errors'
task :reset_sequences => :environment do
  Rails.application.eager_load!
  ActiveRecord::Base.descendants.each do |model|
    unless model.attribute_names.include?('id')
      Rails.logger.debug "Not resetting #{model}, which lacks an ID column"
      next
    end
    begin
      max_id = model.maximum(:id).to_i + 1
      result = ActiveRecord::Base.connection.execute(
        "ALTER SEQUENCE #{model.table_name}_id_seq RESTART #{max_id};"
      )
      Rails.logger.info "Reset #{model} sequence to #{max_id}"
    rescue => e
      Rails.logger.error "Error resetting #{model} sequence: #{e.class.name}/#{e.message}"
    end
  end
end

# ActiveRecord::Base.connection.reset_pk_sequence!('table_name') could be used instead of the above to do only one table/model at a time