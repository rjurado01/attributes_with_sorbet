module Attributes
  def self.included(base)
    base.extend(ClassMethods)
  end

  def initialize(attrs)
    attrs.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  module ClassMethods
    def attribute(attr_name, type: T.unsafe(nil), required: T.unsafe(nil))
      attributes << OpenStruct.new(
        {
          name: attr_name,
          type:,
          required:
        }
      )

      attr_reader(attr_name)
    end

    def attributes
      @attributes ||= []
    end
  end
end
