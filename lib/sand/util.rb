module Sand
  module Util
    def self.constantize(str = '')
      str.split("::").inject(Module) {|acc, val| acc.const_get(val)}
    end
  end
end
