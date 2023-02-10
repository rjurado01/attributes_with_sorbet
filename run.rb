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
end

user = User.new(name: 'Lego', age: 33)

p "Name: #{user.name}, Age: #{user.age}"
