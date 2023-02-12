# frozen_string_literal: true
# typed: true

require 'sorbet-runtime'
require 'ostruct'

require_relative './attributes'

class User
  extend T::Sig

  include Attributes

  attribute :name, type: String
  attribute :age, type: Integer
  attribute :tags, type: Array, array_of: String
end

user = User.new(name: 'Lego', age: 33, tags: ['tag1'])

p "Name: #{user.name}, Age: #{user.age}, Tags: #{user.tags}"
