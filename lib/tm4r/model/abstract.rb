module TM4R

  class TopicMapConstruct < ActiveRecord::Base

    belongs_to :topic_map
    has_many :item_identifiers, :as => :topic_map_construct, :dependent => :destroy

    class << self
      def inheritance_column
        '_type'
      end
      def abstract_class?
        self == TopicMapConstruct
      end
    end

  end


  class Reifiable < TopicMapConstruct
    has_one :reifier, :class_name => "Topic", :as => :reified

    class << self
      def abstract_class?
        self == Reifiable
      end
    end
  end

end
