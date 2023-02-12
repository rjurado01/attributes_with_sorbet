# frozen_string_literal: true
# typed: ignore

module Tapioca
  module Compilers
    # Tapioca compiler for class Attributes
    class Attributes < Tapioca::Dsl::Compiler
      extend T::Sig

      ConstantType = type_member { { fixed: T.class_of(::Attributes) } }

      sig { override.returns(T::Enumerable[Module]) }
      def self.gather_constants
        # Collect all the classes that include Attributes
        all_classes.select { |c| c < ::Attributes }
      end

      sig { override.void }
      def decorate
        # Create a RBI definition for each class that includes Attributes
        root.create_path(constant) do |klass|
          # Create the RBI definitions for all the missing methods
          add_attribute_method(klass)
          add_initialize_method(klass)
          add_attributes_methods(klass)
        end
      end

      private

      sig { override.void }
      def add_attribute_method(klass)
        # https://github.com/Shopify/tapioca/blob/main/lib/tapioca/helpers/rbi_helper.rb
        klass.create_method(
          'attribute',
          parameters: [
            create_param('name', type: 'Symbol'),
            create_kw_opt_param('type', type: 'Class', default: 'T.unsafe(nil)'),
            create_kw_opt_param('array_of', type: 'Class', default: 'T.unsafe(nil)'),
            create_kw_opt_param('optional', type: 'T::Boolean', default: 'T.unsafe(nil)')
          ],
          return_type: 'void',
          class_method: true
        )
      end

      sig { override.void }
      def add_initialize_method(klass)
        klass.create_method(
          'initialize',
          parameters: constant.attributes.map do |attr|
            if attr.type == Array
              create_kw_opt_param(
                attr.name,
                type: "T::Array[#{attr.array_of}]",
                default: 'T.unsafe(nil)'
              )
            else
              create_kw_opt_param(attr.name, type: attr.type.to_s, default: 'T.unsafe(nil)')
            end
          end,
          return_type: 'void'
        )
      end

      sig { override.void }
      def add_attributes_methods(klass)
        # For each attribute we find in the class
        constant.attributes.each do |attr|
          if attr.type == Array
            klass.create_method(attr.name, return_type: "T::Array[#{attr.array_of}]")
          else
            klass.create_method(attr.name, return_type: attr.type)
          end
        end
      end
    end
  end
end
