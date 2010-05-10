module TM4R
  class Occurrence < Reifiable
    belongs_to :topic
    belongs_to :type, :class_name => "Topic"
    has_many :scopes, :as => :scopable, :dependent => :destroy
  end
end
