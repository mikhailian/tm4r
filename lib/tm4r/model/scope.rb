module TM4R

  class Scope < ActiveRecord::Base
    belongs_to :topic
    belongs_to :scopable, :polymorphic => true
  end

end
