SimpleForm.setup do |config|
  config.label_text = lambda { |label, required| "#{label}" }
end

module SimpleForm

  module Inputs
    class Base
    end
  end

end
