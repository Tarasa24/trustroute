module ActiveGraphAdapter
  module Records
    def records
      klass.where(uuid: ids).to_a
    end
  end

  module Callbacks
    def self.included(base)
      base.class_eval do
        after_commit lambda { __elasticsearch__.index_document }, on: :create
        after_commit lambda { __elasticsearch__.update_document }, on: :update
        after_commit lambda { __elasticsearch__.delete_document }, on: :destroy
      end
    end
  end

  module Importing
    def __find_in_batches(options = {}, &block)
      query = options.delete(:query)
      named_scope = options.delete(:scope)
      preprocess = options.delete(:preprocess)

      scope = self
      scope = scope.__send__(named_scope) if named_scope
      scope = scope.instance_exec(&query) if query

      scope.find_in_batches(options) do |batch|
        batch = preprocess.call(batch) if preprocess
        block.call(batch)
      end
    end

    def __transform
      lambda do |model|
        {index: {_id: model.uuid, data: model.as_indexed_json}}
      end
    end
  end
end

# Register the adapter
#
Elasticsearch::Model::Adapter.register(
  ActiveGraphAdapter,
  lambda do |klass|
    klass.ancestors.include?(ActiveGraph::Node)
  end
)
