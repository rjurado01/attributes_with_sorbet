# typed: true

module Tapioca
  module Compilers
    class Attributes < Tapioca::Dsl::Compiler
      extend T::Sig

      ConstantType = type_member {{ fixed: T.class_of(Attributes) }}

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
          # https://github.com/Shopify/tapioca/blob/main/lib/tapioca/helpers/rbi_helper.rb
          klass.create_method(
            'attribute',
            parameters: [
              create_param('name', type: 'Symbol'),
              create_kw_opt_param('type', type: 'Class', default: 'T.unsafe(nil)'),
              create_kw_opt_param('required', type: 'T::Boolean', default: 'T.unsafe(nil)')
            ],
            return_type: 'void',
            class_method: true
          )

          klass.create_method(
            'initialize',
            parameters: constant.attributes.map do |attr|
              create_kw_opt_param(attr.name, type: attr.type.to_s, default: 'T.unsafe(nil)')
            end,
            return_type: 'void'
          )

          # For each attribute we find in the class
          constant.attributes.each do |attr|
            klass.create_method(attr.name, return_type: attr.type)
          end
        end
      end
    end
  end
end
