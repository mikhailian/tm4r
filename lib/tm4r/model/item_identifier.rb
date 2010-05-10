module TM4R

  class ItemIdentifier < ActiveRecord::Base
    # this should introduce a polymorphic association, cf.: http://api.rubyonrails.com/classes/ActiveRecord/Associations/ClassMethods.html
    belongs_to :topic_map_construct, :polymorphic => true

    def topic_map_construct_type=(sType)
      super(sType.to_s.classify.constantize.base_class.to_s)
    end

    def eql?(other)
      self.href == other.href && self.topic_map_construct_type == other.topic_map_construct_type
    end

    def ==(other)
      eql?(other)
    end

  end

end
