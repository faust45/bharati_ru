module Uniq
  extend ActiveSupport::Concern

  class DublicateValue < Exception
    def initialize(klass, value)
      super("Dublicate `#{value}` for #{klass.name}")
    end
  end


  class UniqBase < BaseModel
    use_database SERVER.database!('rocks_cool')
    
    class <<self
      def create(value)
        super('_id' => "#{self.name}/#{value}")

      rescue RestClient::Conflict
        raise DublicateValue.new(self, value)
      end

      def get(value)
        super("#{self.name}/#{value}")
      end
    end
  end


  class <<self
    def create_class(klass, field)
      klass_name = "#{klass.name}#{field.to_s.capitalize}Uniq"
      klass = Object.const_set(klass_name, Class.new(UniqBase))
    end
  end


  module ClassMethods
    def uniq(*fields)
      fields.each do |field|
        uniq_klass = Uniq.create_class(self, field)

        before_save do
          if new?
            uniq_klass.create(self.send(field))
          else
            if field_changed?(field)
              rec = uniq_klass.get(old_value(field))
              rec.destroy
              uniq_klass.create(self.send(field))
            end
          end
        end

        before_destroy do
          rec = uniq_klass.get(self.send(field))
          rec.destroy
        end
      end
    end
  end

end
