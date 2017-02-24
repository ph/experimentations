#!/usr/bin/env ruby
require "bundler/inline"
gemfile do
  source "https://rubygems.org"
  gem "benchmark-ips"
end

class YielderSender
  def yield_something
    yield
  end

  def send_something(name)
    send(name)
  end

  def do_something
    m = 1 + 1
  end
end


require 'benchmark/ips'

yielder = YielderSender.new

Benchmark.ips do |x|
  x.config(:time => 5, :warmup => 2)

  # Typical mode, runs the block as many times as it can
  x.report("yield") do
    yielder.yield_something { yielder.do_something }
  end

  x.report("send") do
    yielder.send_something(:do_something)
  end

  x.compare!
end
