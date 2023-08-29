# frozen_string_literal: true

# Key model
class Key
  include ActiveGraph::Node
  include ActiveGraph::Timestamps

  property :key_id, type: Integer
  property :master, type: Boolean, default: false

  validates :key_id, presence: true, uniqueness: true

  has_many :out, :vouches_for, rel_class: :VouchRelationship
  has_many :in, :is_vouched_for_by, rel_class: :VouchRelationship

  def long_key_id
    format('%08X', key_id).upcase.scan(/.{1,4}/).join(' ')
  end

  def short_key_id
    long_key_id.split(' ')[-2..].join(' ')
  end

  def self.build_with_hex_key_id(key_id)
    throw 'key_id must be a hex string' unless key_id.is_a?(String) && key_id.match?(/^[0-9a-fA-F]+$/)

    key = Key.new
    key.key_id = key_id.to_i(16)

    key
  end
end
