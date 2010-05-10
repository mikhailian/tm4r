require 'test/unit'
require 'lib/tm4r/migrate/001_initial_schema'

module TM4R

  class Simple < Test::Unit::TestCase
    def setup
      InitialSchema.up
    end

    def teardown
      InitialSchema.down
    end

    def test_create_topic_map
      tm = TopicMap.new(:base=>"from_xtm2")
      tm.from_xtm2(File.open("misc/ItalianOpera.xtm2"))
    end

  end

end
