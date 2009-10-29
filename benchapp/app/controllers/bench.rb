class Bench < Application

  def index
    ## steal $stdout
    buf = ''
    def buf.write(arg); self << arg.to_s; end
    $stdout = buf
    ## benchmark target
    klasses = [CallerBenchmark, CallerRetrieveBenchmark,
               CalledFromBenchmark, CalledFromRetrieveBenchmark]
    ## warm up
    n = 10
    Benchmark.bm(45) do |bm|
      klasses.each do |klass| klass.new.call(bm, n) end
    end
    buf[0..-1] = ''   # clear
    ## benchmark
    n = (params[:n] || 100000).to_i
    buf << "*** n=#{n}\n"
    Benchmark.bm(45) do |bm|
      klasses.each do |klass| klass.new.call(bm, n) end
    end
    ##
    return "<pre>#{h(buf)}</pre>"
  ensure
    $stdout = STDOUT
  end

end


class BenchmarkCommand

  def self.title=(title)
    @title = title
  end
  def self.title
    @title
  end

  attr_accessor :title
  def title
    @title || self.class.title
  end

  def call(bm, n)
    bm.report(self.title) do
      (n/10).times do
        perform();  perform();
        perform();  perform();
        perform();  perform();
        perform();  perform();
        perform();  perform();
      end
    end
  end

  def perform(bm, n)
    raise NotImplementedError.new("#{self.class.name}#perform(): not implemented yet.")
  end

end


class CallerBenchmark < BenchmarkCommand
  self.title = "caller()[0]"
  def perform
    caller()[0]
  end
end


class CallerRetrieveBenchmark < BenchmarkCommand
  self.title = "caller()[0]   (get filename and linenum)"
  def perform
    caller()[0] =~ /:(\d+)/; file = $`; line = $1.to_i
  end
end


class CalledFromBenchmark < BenchmarkCommand
  self.title = "called_from()"
  def perform
    called_from()
  end
end


class CalledFromRetrieveBenchmark < BenchmarkCommand
  self.title = "called_from() (get filename and linenum)"
  def perform
    file, line, func = called_from()
  end
end
