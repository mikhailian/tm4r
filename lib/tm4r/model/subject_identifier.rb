module TM4R

  class SubjectIdentifier < ActiveRecord::Base
    belongs_to :topic

    def eql?(other)
      href == other.href
    end

    def ==(other)
      eql?(other)
    end

  end

end
