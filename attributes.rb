# frozen_string_literal: true

# Module to add attributes support to a class
module Attributes
  def self.included(base)
    base.extend(ClassMethods)
  end

  def initialize(attrs)
    attrs.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def validate
    errors = {}

    self.class.attributes.each do |attr|
      attr_errors = check_attr(attr)

      if attr_errors.any?
        errors[attr.name] ||= []
        errors[attr.name].push({ error: :blank })
      end
    end

    throw errors unless errors.keys.empty?
  end

  private

  def check_attr(attr)
    val = instance_variable_get("@#{attr.name}")
    errors = []

    errors.push({ error: :blank }) if !val && !attr.optional

    if val && val.class != attr.type
      errors.push({ error: :invalid_type, expected_type: attr.type })
    end

    errors
  end

  module ClassMethods
    def attribute(attr_name, type: T.unsafe(nil), array_of: T.unsafe(nil), optional: T.unsafe(nil))
      attributes << OpenStruct.new(
        {
          name: attr_name,
          type:,
          array_of:,
          optional:
        }
      )

      attr_reader(attr_name)
    end

    def attributes
      @attributes ||= []
    end
  end
end
