require "elasticsearch/model"

module ElasticSearchable::Key
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    after_save { __elasticsearch__.index_document ignore: 404 }
    after_destroy { __elasticsearch__.delete_document ignore: 404 }

    def as_indexed_json(_options = {})
      as_json(
        root: false,
        except: %i[fingerprint],
        methods: %i[name sha long_sha keyid],
        include: {
          indexable_oauth_identities: {
            only: %i[info provider]
          },
          indexable_email_identities: {
            only: %i[email]
          },
          indexable_dns_identities: {
            only: %i[domain]
          },
          aliases: {}
        }
      )
    end

    def self.search(query)
      el = begin 
      __elasticsearch__.search(
        query: {
          bool: {
            should: [
              {
                multi_match: {
                  query: query,
                  type: "bool_prefix",
                  fields: %w[name^5 aliases.name^5 aliases.email^5 aliases.uid^5 indexable_email_identities.email^5 indexable_dns_identities.domain^5 indexable_oauth_identities.info^5]
                }
              },
              {
                multi_match: {
                  query: query,
                  type: "phrase_prefix",
                  fields: %w[name^5 aliases.name^5 aliases.email^5 aliases.uid^5 indexable_email_identities.email^5 indexable_dns_identities.domain^5 indexable_oauth_identities.info^5]
                }
              }
            ]
          }
        }
      )
      rescue Elasticsearch::Transport::Transport::Errors::BadRequest
        []
      end

      # Query for exact matches directly in the db
      keys = Key.by_query(query)

      # Merge the results
      keys.to_a + el.records

      # Remove duplicates
      keys.uniq

      # Remove invalid keys
      keys.select(&:valid?)
    end

    private

    def indexable_oauth_identities
      oauth_identities.select(&:validated?)
    end

    def indexable_email_identities
      email_identities.select(&:validated?)
    end

    def indexable_dns_identities
      dns_identities.select(&:validated?)
    end

    settings index: {number_of_shards: 1} do
      mappings dynamic: false do
        indexes :name, type: :search_as_you_type
        indexes :sha, type: :keyword
        indexes :long_sha, type: :keyword
        indexes :keyid, type: :search_as_you_type
        indexes :indexable_oauth_identities, type: :nested do
          indexes :info, type: :text, fields: {keyword: {type: :keyword}}
          indexes :provider, type: :keyword
        end
        indexes :indexable_email_identities, type: :nested do
          indexes :email, type: :text, fields: {keyword: {type: :keyword}}
        end
        indexes :indexable_dns_identities, type: :nested do
          indexes :domain, type: :text, fields: {keyword: {type: :keyword}}
        end
        indexes :aliases, type: :nested do
          indexes :name, type: :search_as_you_type
          indexes :email, type: :search_as_you_type
          indexes :uid, type: :search_as_you_type
        end
      end
    end
  end
end
