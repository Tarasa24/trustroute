namespace :elasticsearch do
  desc "Create the Elasticsearch index"
  task :create_index, [:model] => :environment do |t, args|
    model = args[:model].constantize
    model.__elasticsearch__.create_index! unless model.__elasticsearch__.index_exists?
  end
end
