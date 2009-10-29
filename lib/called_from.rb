###
### $Release: $
### $Copyright$
### $License$
###

begin
  require 'called_from.so'
rescue LoadError

  module ::Kernel
    def called_from(level=1)
      arrs = caller((level||1)+1)  or return
      arrs[0] =~ /:(\d+)(?::in `(.*)')?/ ? [$`, $1.to_i, $2] : nil
    end
  end

end
