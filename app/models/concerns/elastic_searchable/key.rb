require "elasticsearch/model"

module ElasticSearchable::Key
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    after_save { __elasticsearch__.index_document }
    after_destroy { __elasticsearch__.delete_document }

    def as_indexed_json(_options = {})
      as_json(
        root: false,
        except: %i[fingerprint],
        methods: %i[name sha long_sha keyid],
        include: {identities: {only: %i[info provider email]}}
      )
    end

    settings index: {number_of_shards: 1},
      analysis: {
        char_filter: {
          remove_spaces: {type: "pattern_replace", pattern: " ", replacement: ""}
        },
        analyzer: {
          edge_ngram_analyzer: {tokenizer: "edge_ngram_tokenizer"},
          prefix_analyzer: {
            tokenizer: "keyword", filter: %w[lowercase prefix_filter], char_filter: %w[remove_spaces]
          }
        },
        tokenizer: {
          edge_ngram_tokenizer: {
            type: "edge_ngram",
            min_gram: 2,
            max_gram: 10,
            token_chars: %w[letter digit symbol punctuation]
          }
        },
        filter: {
          prefix_filter: {type: "edge_ngram", min_gram: 2, max_gram: 20}
        }
      } do
      mappings dynamic: false do
        indexes :name, type: :text, analyzer: "edge_ngram_analyzer", search_analyzer: "standard"
        indexes :sha, type: :keyword, fields: {prefix: {type: :text, analyzer: "prefix_analyzer"}}
        indexes :long_sha, type: :keyword, fields: {prefix: {type: :text, analyzer: "prefix_analyzer"}}
        indexes :keyid, type: :keyword, fields: {prefix: {type: :text, analyzer: "prefix_analyzer"}}
        indexes :identities do
          indexes :provider, type: :keyword
          indexes :info, type: :object, dynamic: true
          indexes :email, type: :text, analyzer: "edge_ngram_analyzer", search_analyzer: "standard"
        end
      end
    end
  end
end
