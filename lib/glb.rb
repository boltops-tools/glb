$stdout.sync = true unless ENV["GLB_STDOUT_SYNC"] == "0"

$:.unshift(File.expand_path("../", __FILE__))

require "glb/autoloader"
Glb::Autoloader.setup

require "memoist"
require "rainbow/ext/string"
require "active_support"
require "active_support/core_ext/hash"
require "active_support/core_ext/string"
require "json"
require "dsl_evaluator"

DslEvaluator.backtrace_reject = "lib/glb"

module Glb
  extend Memoist
  class Error < StandardError; end
  extend Core
end
