# frozen_string_literal: true

module DryValidationParser
  class ValidationSchemaParser
    PREDICATE_TO_TYPE = {
      array?: "array",
      bool?: "boolean",
      date?: "date",
      date_time?: "datetime",
      decimal?: "decimal",
      float?: "float",
      hash?: "hash",
      int?: "integer",
      nil?: "nil",
      str?: "string",
      time?: "time",
      uuid_v1?: "uuid",
      uuid_v2?: "uuid",
      uuid_v3?: "uuid",
      uuid_v4?: "uuid",
      uuid_v5?: "uuid"
    }.freeze

    DESCRIPTION_MAPPING = {
      eql?: "Must be equal to %<value>s",
      max_size?: "Maximum size: %<value>s",
      min_size?: "Minimum size: %<value>s",
      gteq?: "Greater than or equal to %<value>s",
      gt?: "Greater than %<value>s",
      lt?: "Lower than %<value>s",
      lteq?: "Lower than or equal to %<value>s"
    }.freeze

    # @api private
    attr_reader :keys

    # @api private
    def initialize
      @keys = {}
    end

    # @api private
    def to_h
      { keys: keys }
    end

    # @api private
    def call(contract, &block)
      @keys = {}
      visit(contract.schema.to_ast)
      instance_eval(&block) if block_given?
      self
    end

    # @api private
    def visit(node, opts = {})
      meth, rest = node
      public_send(:"visit_#{meth}", rest, opts)
    end

    def visit_namespace(node, opts = {})
      visit(node[1], opts)
    end

    # @api private
    def visit_set(node, opts = {})
      target = (key = opts[:key]) ? self.class.new : self

      node.map { |child| target.visit(child, opts) }

      return unless key

      target_info = target.to_h
      type = keys[key][:array] ? "array" : "hash"

      keys.update(key => { **keys[key], type: type, **target_info })
    end

    # @api private
    def visit_and(node, opts = {})
      left, right = node

      visit(left, opts)
      visit(right, opts)
    end

    # Skip or predicate
    def visit_or(_, _); end

    def visit_not(_node, opts = {})
      keys[opts[:key]][:nullable] = true
    end

    # @api private
    def visit_implication(node, opts = {})
      node.each do |el|
        opts = opts.merge(required: false)
        visit(el, opts)
      end
    end

    # @api private
    def visit_each(node, opts = {})
      visit(node, opts.merge(member: true))
    end

    # @api private
    def visit_key(node, opts = {})
      name, rest = node
      opts = opts.merge(key: name)
      opts = opts.merge(required: true)
      visit(rest, opts)
    end

    # @api private
    def visit_predicate(node, opts = {})
      name, rest = node
      key = opts[:key]
      if name.equal?(:key?)
        keys[rest[0][1]] = { required: opts.fetch(:required, true) }
      elsif name.equal?(:array?)
        keys[key][:array] = true
      elsif name.equal?(:included_in?)
        keys[key][:enum] = rest[0][1]
        keys[key][:enum] += [nil] if opts.fetch(:nullable, false)
      elsif PREDICATE_TO_TYPE[name]
        keys[key][:type] = PREDICATE_TO_TYPE[name]
      else
        description = predicate_description(name, rest[0][1].to_s)
        if keys[key][:description].to_s.empty?
          keys[key][:description] = description unless description.to_s.empty?
        else
          keys[key][:description] += ", #{description}" unless description.to_s.empty?
        end
      end
    end

    def predicate_description(name, value)
      description = DESCRIPTION_MAPPING[name]
      description ? format(description, value: value) : ""
    end
  end
end
