module TM4R
  class Variant < Reifiable
    belongs_to :name
    has_many :scopes, :as => :scopable, :dependent => :destroy
    def <=>(other)
        self.value <=> other.value
    end
  end
end
