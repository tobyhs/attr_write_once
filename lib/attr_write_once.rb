require 'set'

# @see #attr_write_once
module AttrWriteOnce
  # This exception is raised when one tries to write to an attribute after it
  # has been written to once.
  class WriteLimitExceeded < StandardError; end

  private

  # Creates reader and one-time writer methods for the given attribute names.
  #
  # @param [Array<#to_sym>] attributes
  def attr_write_once(*attributes)
    attr_reader(*attributes)
    attributes.map(&:to_sym).each do |attribute|
      define_method("#{attribute}=") do |value|
        @_attr_write_once ||= Set.new
        if @_attr_write_once.add?(attribute)
          instance_variable_set("@#{attribute}", value)
        else
          raise WriteLimitExceeded, "#{attribute} has already been set"
        end
      end
    end
  end
end
