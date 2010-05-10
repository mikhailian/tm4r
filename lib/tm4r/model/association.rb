module TM4R
  class Association < Reifiable
    belongs_to :type, :class_name => "Topic"
    has_many :roles, :dependent => :destroy
    has_many :players, :through=> :roles
    has_many :scopes, :as => :scopable, :dependent => :destroy

    def Association.type_instance(tm)
      association =Association.new(:topic_map_id=>tm.id)
      topic = Topic.by_si(tm, "http://psi.topicmaps.org/iso13250/model/type-instance")
      association.type = topic
      return association
    end

    def Association.supertype_subtype(tm)
      association =Association.new(:topic_map_id=>tm.id)
      topic = Topic.by_si(tm, "http://psi.topicmaps.org/iso13250/model/supertype-subtype")
      association.type = topic
      return association
    end
  end
end
