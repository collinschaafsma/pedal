module Pedal
  # Derived / Lifted from https://github.com/dewski/json_builder
  class InvalidArgument < StandardError; end
  class MissingKeyError < StandardError; end

  class Builder
    attr_accessor :members
    attr_accessor :scope
    attr_accessor :array

    undef_method :id if methods.include? 'id'

    def self.build(*args, &block)
      options = args.last.is_a?(::Hash) ? args.pop : {}
      builder = self.new(options)
      builder.build(*args, &block)
      eval(builder.to_s)
    end

    def initialize(options={})
      @_members = []
      @_scope = options[:scope]

      copy_instance_variables_from(@_scope) if @_scope
    end

    def build(*args, &block)
      instance_exec(*args, &block)
    end

    def method_missing(key_name, *args, &block)
      if @_scope.respond_to?(key_name) && !ignore_scope_methods.include?(key_name)
        @_scope.send(key_name, *args, &block)
      else
        key(key_name, *args, &block)
      end
    end

    def key(key_name, *args, &block)
      member = Member.new(key_name, @_scope, *args, &block)
      @_members << member
      member
    end

    def array(items, &block)
      @_array = Elements.new(@_scope, items, &block)
    end

    def to_s
      @_array ? @_array.to_s : "{#{@_members.collect(&:to_s).join(', ')}}"
    end

    private
    def copy_instance_variables_from(object, exclude = []) #:nodoc:
      vars = object.instance_variables.map(&:to_s) - exclude.map(&:to_s)
      vars.each { |name| instance_variable_set(name.to_sym, object.instance_variable_get(name)) }
    end

    def ignore_scope_methods
      [:id]
    end
  end

  class Member
    attr_accessor :key, :value

    def initialize(key, scope, *args, &block)
      raise MissingKeyError if key.nil?

      @key = key

      argument = args.shift
      if argument.is_a?(Array) || defined?(ActiveRecord::Relation) && argument.is_a?(ActiveRecord::Relation)
        @value = Elements.new(scope, argument, &block)
      else
        @value = Value.new(scope, argument, &block)
      end
    end

    def to_s
      "#{@key}: #{@value}"
    end
  end

  class Elements
    attr_accessor :builders

    def initialize(scope, items, &block)
      raise InvalidArgument.new('items does not respond to each') unless items.respond_to?(:each)

      @builders = []

      items.each do |item|
        @builders << Value.new(scope, item, &block)
      end
    end

    def to_s
      "[#{@builders.collect(&:to_s).join(', ')}]"
    end
  end

  class Value
    attr_accessor :value

    def initialize(scope, arg, &block)
      if block_given?
        @value = Builder.new(:scope => scope)
        built = @value.build(arg, &block)

        # For the use case that the passed in block returns a non-member object
        # or normal Ruby object
        @value = built unless built.is_a?(Member)
      else
        @value = arg
      end
    end

    def to_s
      @value.is_a?(::String) ? "\"#{@value.to_s}\"" : @value.to_s
    end
  end
end
