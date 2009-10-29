###
### $Release: $
### $Copyright$
### $License$
###

require 'test/unit'
begin
  require 'called_from.so'
rescue LoadError => x
  $: << File.join(File.dirname(__FILE__), '..', 'lib')
  require 'called_from.rb'
end


class CalledFromTest < Test::Unit::TestCase

  def setup
    @fname = File.basename(__FILE__)
    @fname = File.join('test', @fname) if File.basename(Dir.pwd) != 'test'
  end

  def f1
    f2()
  end

  def f2
    f3()
  end

  def f3
    f4()
  end

  def f4
    called_from(@level)
  end

  def test_level_nil
    if :'called then returns array of filename, line number, and function name'
      @level = nil
      arr = f1()
      assert_equal("[\"#{@fname}\", #{32}, \"f3\"]", arr.inspect)
    end
  end

  def test_level_1
    if :'called without args then returns the same as arg 1 specified'
      @level = 1
      arr1 = f1()
      @level = nil
      arr0 = f1()
      assert_equal(arr1.inspect, arr0.inspect)
    end
  end

  def test_level_n
    if :'called with level then returns array according to level'
      @level = 2
      assert_equal("[\"#{@fname}\", #{28}, \"f2\"]", f1().inspect)
      @level = 3
      assert_equal("[\"#{@fname}\", #{24}, \"f1\"]", f1().inspect)
    end
  end

  def test_level_too_deep
    if :'called with too deep level then returns nil'
      @level = 100
      assert_nil(f1())
    end
  end

  def test_level_top
    if :'caller is not found then function name is nil'
      @level = 100
      while (ret = f1()).nil?
        @level -= 1
      end
      #$stderr.puts "*** debug: ret=#{ret.inspect}"
      assert_kind_of(String, ret[0])
      assert_kind_of(Fixnum, ret[1])
      assert_nil(ret[2])
    end
  end

end
