class KeySerializer < ActiveModel::Serializer
  attributes :id, :sha
  attribute :is_self, if: :is_self

  def is_self
    return false unless instance_options[:current_key]

    instance_options[:current_key] == object
  end
end
