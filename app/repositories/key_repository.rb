class KeyRepository
  include Elasticsearch::Persistence::Repository
  include Elasticsearch::Persistence::Repository::DSL

  client Elasticsearch::Client.new url: "http://localhost:9200", log: true

  klass Key
  index_name "keys"

  settings number_of_shards: 1 do
    mapping do
      indexes :fingerprint, analyzer: "snowball", type: "text"
    end
  end

  def deserialize(document)
    klass.find(document["_source"]["uuid"])
  end
end
