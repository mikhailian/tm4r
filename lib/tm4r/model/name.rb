module TM4R
  class Name < Reifiable
    belongs_to :topic
    # # attribute :value, :class_name => "String" 
    belongs_to :type, :class_name => "Topic"
    has_many :variants, :dependent => :destroy
    has_many :scopes, :as => :scopable

    def <=>(other)
        self.value <=> other.value
    end

    def ==(other)
      self.value == other.value && self.topic == other.topic
    end

    def eql?(other)
      self == other
    end

    def hash
      self.value.hash
    end
  end
end
