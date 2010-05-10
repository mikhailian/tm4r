module TM4R

  class SubjectLocator < ActiveRecord::Base
    belongs_to :topic

    def eql?(other)
      href == other.href
    end

    def ==(other)
      eql?(other)
    end

  end

end
