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
      topic_map = TopicMap.new(:base=>"simple")
      topic_map.save
    end

    def test_create_topic
      topic_map = TopicMap.new
      topic_map.save
      topic = Topic.new
      topic_map.topics << topic
      topic.save
    end

    def test_by_item_identifier
      topic_map = TopicMap.new
      topic = Topic.new
      topic_map.topics << topic
      item_identifier = ItemIdentifier.new :href=>"one"
      topic.item_identifiers << item_identifier
      topic_map.save
      topic.save

      assert_equal(nil, (topic_map.topics.by_item_identifier("two")))
      assert_not_equal(nil, (topic_map.topics.by_item_identifier("one")))
    end

  end

end
