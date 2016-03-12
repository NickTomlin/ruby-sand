module Sand
  module Util
    def self.constantize(str = '')
      str.split('::').inject(Module) { |a, e| a.const_get(e) }
    end
  end
end
