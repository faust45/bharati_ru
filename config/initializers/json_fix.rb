module JSONFix
  def self.included(base)
    base.class_eval do
      undef to_json
      def to_json(options = nil)
        ActiveSupport::JSON.encode(self, options)
      end
    end
  end
end

[
  Hash, 
  Array, 
  String, 
  Numeric, 
  TrueClass, 
  FalseClass, 
  BigDecimal
].each {|c| c.send(:include, JSONFix) }
