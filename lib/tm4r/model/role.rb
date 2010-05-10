module TM4R
  class Role < Reifiable
    belongs_to :association
    belongs_to :player, :class_name => "Topic"
    belongs_to :type, :class_name => "Topic"

    def other_roles
      Role.other_roles(self.id)
    end

    def Role.type(tm, player)
      Role.new(:player=>player,:type=>Topic.type(tm))
    end

    def Role.instance(tm, player)
      Role.new(:player=>player,:type=>Topic.instance(tm))
    end

    def Role.supertype(tm, player)
      Role.new(:player=>player,:type=>Topic.supertype(tm))
    end

    def Role.subtype(tm, player)
      Role.new(:player=>player,:type=>Topic.subtype(tm))
    end

    class << self

      OTHER_ROLES =
      %{SELECT r2.* from roles r2
      JOIN (associations a, roles r1)
      ON (a.id=r1.association_id AND a.id=r2.association_id)
      WHERE r1.id = ? AND r2.id != ?}

      def other_roles(id)
      find_by_sql([OTHER_ROLES, id, id])
      end
    end
  end

end
