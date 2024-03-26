require "elasticsearch/model"

module ElasticSearchable::Identities
  extend ActiveSupport::Concern

  included do
    after_save { key.__elasticsearch__.index_document }
    after_destroy { key.__elasticsearch__.delete_document }
  end
end
