module TM4R

  class TopicMap < Reifiable

    # attribute :base, :class_name => "String"
    has_many :associations
    has_many :occurrences, :through => :topics
    has_many :topics do
      # search by the item_identifer/href
      def by_item_identifier(href)
        find(:first,
          :joins=>"JOIN item_identifiers ON topics.id=item_identifiers.topic_map_construct_id",
          :readonly=>false,
          :conditions=>["href=?", href])
      end
    end

    def from_xtm2(source, options={})
      listener = XTM2Listener.new(self, options)
      begin
        parser = REXML::Parsers::SAX2Parser.new(source)
        parser.listen(listener)
        parser.parse
      rescue => exception
        print exception.message
        print exception.backtrace.join("\n")
        print "\nlast path is #{listener.path.join(" ")}\n"
        print "stack in reverse order: "
        until listener.stack.empty?
          result = listener.stack.pop
          print "#{result.inspect}, ids:"
          print result.item_identifiers.join(" ")
          print "\n"
        end
      end
    end
  end
end
