module TM4R
  require 'set' # for ancestors
  class Topic < TopicMapConstruct
    has_many :names, :class_name => "Name", :dependent => :destroy
    has_many :occurrences, :dependent => :destroy
    has_many :subject_identifiers, :dependent => :destroy
    has_many :subject_locators, :dependent => :destroy
    belongs_to :reified, :polymorphic => true
    has_one :reifier, :class_name=> "Topic", :foreign_key=> "reified_id"
    has_many :roles, :foreign_key=> "player_id", :dependent => :destroy
    has_many :associations, :through => :roles
    #before_create :merge

    def to_s
     names[0..2].collect{|n| n.value}.join("; ")
    end

    def hash
      self.id
    end

    def eql?(other)
      self.id == other.id
    end

    # role types that the topic has in associations
    def roles_from_player
        Topic.roles_from_player(self.id)
    end

    # types of associations that this topic participates
    def associations_from_player
        Topic.associations_from_player(self.id)
    end

    # topics that this topic associated with
    def other_players_from_player
      Topic.other_players_from_player(self.id)
    end

    # role players that that have this topic as role type
    def players_from_role
        Topic.players_from_role(self.id)
    end

    # associations that has this topic as role type
    def associations_from_role
        Topic.associations_from_role(self.id)
    end

    # players in the associations of this particular type
    def players_from_association
       Topic.players_from_association(self.id)
    end

    # roles in the associations of this particular type
    def roles_from_association
       Topic.roles_from_association(self.id)
    end

    # instances of this topic
    def instances
        Topic.instances(self.id)
    end

    # deep instances
    def descendants
       results = Set.new
       results.merge instances
       subtypes.each {|subtype|
        results.merge subtype.descendants
       }
    end

    # deep types
    def ancestors
       results = Set.new
       supertypes.each {|supertype|
         results.add supertype
         results.merge supertype.ancestors
       }
       types.each {|type|
         results.add type
         results.merge type.ancestors
       }
       results.to_a
    end

    # types of this topic
    def types
        Topic.types(self.id)
    end

    def subtypes
        Topic.subtypes(self.id)
    end

    def supertypes
        Topic.supertypes(self.id)
    end

    # is this topic used as a role player?
    def role_player?
      Topic.role_player?(self.id)
    end

    # is this topic used to type other topics?
    def topic_type?
      Topic.topic_type?(self.id)
    end

    # is this topic an instance of some other topic?
    def topic_instance?
      Topic.topic_instance?(self.id)
    end

    # is this topic used as a supertype of some other topic?
    def topic_supertype?
      Topic.topic_supertype?(self.id)
    end

    # is this topic used as a subtype of some other topic?
    def topic_subtype?
      Topic.topic_subtype?(self.id)
    end

    # is this topic used as a name type?
    def name_type?
      Topic.name_type?(self.id)
    end

    # is this topic used as an association type?
    def association_type?
      Topic.association_type?(self.id)
    end

    # is this topic used as an occurrence type?
    def occurrence_type?
      Topic.occurrence_type?(self.id)
    end

    # is this topic used as a role type?
    def role_type?
      Topic.role_type?(self.id)
    end

    # is this topic used as a name scope?
    def name_scope?
      Topic.name_scope?(self.id)
    end

    # is this topic used as a variant scope?
    def variant_scope?
      Topic.variant_scope?(self.id)
    end

    # is this topic used as an occurrence scope?
    def occurrence_scope?
      Topic.occurrence_scope?(self.id)
    end

    # is this topic used as an association scope?
    def association_scope?
      Topic.association_scope?(self.id)
    end

    # is this topic used as a topic map reifier?
    def topic_map_reifier?
      Topic.topic_map_reifier?(self.id)
    end

    # is this topic used as a name reifier?
    def name_reifier?
      Topic.name_reifier?(self.id)
    end

    # is this topic used as an association reifier?
    def association_reifier?
      Topic.association_reifier?(self.id)
    end

    # is this topic used as an occurrence reifier?
    def occurrence_reifier?
      Topic.occurrence_reifier?(self.id)
    end

    # is this topic used as a role reifier?
    def role_reifier?
      Topic.role_reifier?(self.id)
    end

    # is this topic used as a variant reifier?
    def variant_reifier?
      Topic.variant_reifier?(self.id)
    end


    def merge
      topics = find_equal
      return true if topics.empty?
      print "self.id: #{self.id}\n"
      $stderr << "Size of equal topics: #{topics.size}\n"
      $stderr << "topics.empty?: #{topics.empty?}\n"
      last = topics.pop
      Topic.merge(self, last)
      Topic.delete(self.id) if self.id
      self.freeze
      last.save
      last.merge
      return false
    end

    def find_equal
      iis_sis=[]
      item_identifiers.each {|item_identifier|
        iis_sis.push item_identifier.href
      }
      subject_identifiers.each {|subject_identifier|
        iis_sis.push subject_identifier.href
      }
      sls=[]
      subject_locators.each{|subject_locator|
        sls.push subject_locator.href
      }
      if self.id && self.topic_map_id
        Topic.find(:all,
          :conditions=>[%{((item_identifiers.href IN (?)
            OR subject_identifiers.href IN (?))
            OR subject_locators.href IN (?))
            AND NOT topics.id = ?
            AND topics.topic_map_id= ?}, iis_sis, iis_sis, sls, self.id, self.topic_map_id],
          :include =>
            [:item_identifiers, :subject_identifiers, :subject_locators])
      elsif self.topic_map_id
        Topic.find(:all,
          :conditions=>[%{(item_identifiers.href IN (?)
            OR subject_identifiers.href IN (?))
            OR subject_locators.href IN (?)
            AND topics.topic_map_id = ? }, iis_sis, iis_sis, sls, self.topic_map_id],
          :include =>
            [:item_identifiers, :subject_identifiers, :subject_locators])
      else
        $stderr << "#{__FILE__}:#{__LINE__} entered, this should never happen.\n"
        []
      end
    end

    def Topic.merge(from, to)
      #to.names = to.names | from.names
      from.names.each {|n|
        n.topic = to
        n.save
      }
      #to.occurrences = to.occurrences | from.occurrences
      from.occurrences.each {|o|
        o.topic = to
        n.save
      }
      #to.subject_identifiers =
      #   to.subject_identifiers | from.subject_identifiers
      from.subject_identifiers.each {|si|
        si.topic = to unless to.subject_indentifier.member?(si)
        si.save
      }
      #to.subject_locators = to.subject_locators | from.subject_locators
      from.subject_locators.each {|sl|
        sl.topic = to unless to.subject_locators.member?(sl)
        sl.save
      }
      #to.item_identifiers = to.item_identifiers | from.item_identifiers
      from.item_identifiers.each {|ii|
        unless to.item_identifiers.member?(ii)
          ii.topic_map_construct = to
          ii.topic_map_construct_type =
            Topic.to_s.classify.constantize.base_class.to_s
          ii.save
        end
      }
      # TODO move associations
    end

    class << self

      ROLES_FROM_PLAYER=
      %{SELECT t.* from topics t
      JOIN (roles r)
      ON (r.type_id=t.id)
      WHERE r.player_id=?}

      ASSOCIATIONS_FROM_PLAYER=
      %{SELECT t.* from topics t
      JOIN (associations a, roles r)
      ON (r.association_id=a.id AND a.type_id=t.id)
      WHERE r.player_id=?}

      OTHER_PLAYERS_FROM_PLAYER=
      %{SELECT DISTINCT t2.*
      FROM topics t2
      JOIN (associations a,
        roles r1, roles r2)
      ON (r1.association_id = a.id AND
          r2.association_id = a.id AND
          r2.player_id      = t2.id)
      WHERE r1.player_id=?  AND NOT t2.id = ?}

      PLAYERS_FROM_ROLE=
      %{SELECT DISTINCT t.* from topics t
      JOIN (roles r)
      ON (r.player_id=t.id)
      WHERE r.type_id=?}

      ASSOCIATIONS_FROM_ROLE=
      %{SELECT DISTINCT t.* from topics t
      JOIN (roles r, associations a)
      ON (r.association_id_id=a.id AND
          a.type_id=t.id)
      WHERE r.type_id=?}

      PLAYERS_FROM_ASSOCIATION=
      %{SELECT DISTINCT t.* from topics t
      JOIN (associations a, roles r)
      ON (a.id = r.association_id AND r.player_id=t.id)
      WHERE a.type_id=?}

      ROLES_FROM_ASSOCIATION=
      %{SELECT DISTINCT t.* from topics t
      JOIN (associations a, roles r)
      ON (a.id = r.association_id AND r.type_id=t.id)
      WHERE a.type_id=?}

      SQL_XXX =
      %{SELECT DISTINCT tpt.*
      FROM topics tpt
      JOIN (subject_identifiers si,
        associations a,
        roles rt,
        roles ri)
      ON (ri.association_id=a.id
        AND rt.association_id=a.id AND
         rt.type_id=si.topic_id AND
         rt.player_id = tpt.id)
      WHERE si.href=?
        AND ri.player_id=?
        AND NOT tpt.id = ?}

      SQL_IS_ROLE_PLAYER =
      %{SELECT id FROM roles WHERE player_id=? LIMIT 1}

      SQL_IS_XXX =
      %{SELECT p.id
      FROM topics p
      JOIN (subject_identifiers si, roles r, topics t)
      WHERE si.href=?
        AND si.topic_id=t.id AND r.type_id=t.id
        AND r.player_id=p.id AND p.id=? LIMIT 1}

      SQL_IS_NAME_TYPE =
      %{SELECT id FROM names WHERE type_id=? LIMIT 1}

      SQL_IS_ASSOCIATION_TYPE =
      %{SELECT id FROM associations WHERE type_id=? LIMIT 1}

      SQL_IS_OCCURRENCE_TYPE =
      %{SELECT id FROM occurrences WHERE type_id=? LIMIT 1}

      SQL_IS_ROLE_TYPE =
      %{SELECT id FROM roles WHERE type_id=? LIMIT 1}

      SQL_IS_NAME_SCOPE =
      %{SELECT id FROM scopes
      WHERE scopable_type="TM4R::Name" AND topic_id=? LIMIT 1}

      SQL_IS_VARIANT_SCOPE =
      %{SELECT id FROM scopes
      WHERE scopable_type="TM4R::Variant" AND topic_id=? LIMIT 1}

      SQL_IS_OCCURRENCE_SCOPE =
      %{SELECT id FROM scopes
      WHERE scopable_type="TM4R::Occurrence" AND topic_id=? LIMIT 1}

      SQL_IS_ASSOCIATION_SCOPE =
      %{SELECT id FROM scopes
      WHERE scopable_type="TM4R::Association" AND topic_id=?}

      SQL_IS_TOPIC_MAP_REIFIER =
      %{SELECT id FROM topics
      WHERE reified_id IS NOT NULL
      AND reified_type="TM4R::TopicMap" AND id=?}

      SQL_IS_NAME_REIFIER =
      %{SELECT id FROM topics
      WHERE reified_id IS NOT NULL
      AND reified_type="TM4R::Name" AND id=?}

      SQL_IS_ASSOCIATION_REIFIER =
      %{SELECT id FROM topics
      WHERE reified_id IS NOT NULL
      AND reified_type="TM4R::Association" AND id=?}

      SQL_IS_OCCURRENCE_REIFIER =
      %{SELECT id FROM topics
      WHERE reified_id IS NOT NULL
      AND reified_type="TM4R::Occurrence" AND id=?}

      SQL_IS_ROLE_REIFIER =
      %{SELECT id FROM topics
      WHERE reified_id IS NOT NULL
      AND reified_type="TM4R::Role" AND id=?}

      SQL_IS_VARIANT_REIFIER =
      %{SELECT id FROM topics
      WHERE reified_id IS NOT NULL
      AND reified_type="TM4R::Variant" AND id=?}

      SQL_BY_NAME =
      %{SELECT DISTINCT t.id FROM topics t
      JOIN (names n) ON (t.id=n.topic_id)
      WHERE (n.value LIKE ?)
      AND t.topic_map_id = ?}

      SQL_BY_NAME_AND_VARIANT =
      %{SELECT DISTINCT t.id FROM topics t
      LEFT OUTER JOIN (names n) ON (t.id=n.topic_id)
      LEFT OUTER JOIN (variants v)  ON (t.id=n.topic_id AND n.id=v.name_id)
      WHERE (n.value LIKE ? OR v.value like ?)
      AND t.topic_map_id = ?}

      SQL_BY_NAME_AND_VARIANT_AND_OCCURRENCE =
      %{SELECT DISTINCT t.id FROM topics t
      LEFT OUTER JOIN (names n) ON (t.id=n.topic_id)
      LEFT OUTER JOIN (variants v)  ON (t.id=n.topic_id AND n.id=v.name_id)
      LEFT OUTER JOIN (occurrences o)  ON (t.id=o.topic_id)
      WHERE (n.value LIKE ? OR v.value like ? OR o.value like ?)
      AND t.topic_map_id = ?}

      SQL_TOPIC_ID_BY_II_OR_SI =
      %{SELECT t.* FROM topics t
      JOIN item_identifiers ii
      ON ii.topic_map_construct_id = t.id AND ii.topic_map_construct_type = 'TM4R::Topic'
      WHERE ii.href = ? AND t.topic_map_id = ?
      UNION
      SELECT t.* FROM topics t
      JOIN subject_identifiers si ON si.topic_id = t.id
      WHERE si.href = ?  AND t.topic_map_id = ?}

      def roles_from_player(topic_id)
          find_by_sql([ROLES_FROM_PLAYER, topic_id])
      end

      def associations_from_player(topic_id)
          find_by_sql([ASSOCIATIONS_FROM_PLAYER, topic_id])
      end

      def other_players_from_player(topic_id)
          find_by_sql([OTHER_PLAYERS_FROM_PLAYER, topic_id, topic_id])
      end

      def players_from_role(topic_id)
          find_by_sql([PLAYERS_FROM_ROLE, topic_id])
      end

      def associations_from_role(topic_id)
          find_by_sql([ASSOCIATIONS_FROM_ROLE, topic_id])
      end

      def players_from_association(topic_id)
          find_by_sql([PLAYERS_FROM_ASSOCIATION, topic_id])
      end

      def roles_from_association(topic_id)
          find_by_sql([ROLES_FROM_ASSOCIATION, topic_id])
      end

      def instances(topic_id)
          find_by_sql([SQL_XXX, PSI[:instance],  topic_id, topic_id])
      end

      def types(topic_id)
          find_by_sql([SQL_XXX, PSI[:type],      topic_id, topic_id])
      end

      def subtypes(topic_id)
          find_by_sql([SQL_XXX, PSI[:subtype],   topic_id, topic_id])
      end

      def supertypes(topic_id)
          find_by_sql([SQL_XXX, PSI[:supertype], topic_id, topic_id])
      end

      def role_player?(topic_id)
          Topic.find_by_sql([SQL_IS_ROLE_PLAYER, topic_id]).size != 0
      end

      def topic_type?(topic_id)
          Topic.find_by_sql([SQL_IS_XXX, PSI[:type], topic_id]).size != 0
      end

      def topic_instance?(topic_id)
          Topic.find_by_sql([SQL_IS_XXX, PSI[:instance], topic_id]).size != 0
      end

      def topic_supertype?(topic_id)
          Topic.find_by_sql([SQL_IS_XXX, PSI[:supertype], topic_id]).size != 0
      end

      def topic_subtype?(topic_id)
          Topic.find_by_sql([SQL_IS_XXX, PSI[:subtype], topic_id]).size != 0
      end

      def name_type?(topic_id)
          Topic.find_by_sql([SQL_IS_NAME_TYPE, topic_id]).size != 0
      end

      def association_type?(topic_id)
          Topic.find_by_sql([SQL_IS_ASSOCIATION_TYPE, topic_id]).size != 0
      end

      def occurrence_type?(topic_id)
          Topic.find_by_sql([SQL_IS_OCCURRENCE_TYPE, topic_id]).size != 0
      end

      def role_type?(topic_id)
          Topic.find_by_sql([SQL_IS_ROLE_TYPE, topic_id]).size != 0
      end

      def name_scope?(topic_id)
          Topic.find_by_sql([SQL_IS_NAME_SCOPE, topic_id]).size != 0
      end

      def variant_scope?(topic_id)
          Topic.find_by_sql([SQL_IS_VARIANT_SCOPE, topic_id]).size != 0
      end

      def occurrence_scope?(topic_id)
          Topic.find_by_sql([SQL_IS_OCCURRENCE_SCOPE, topic_id]).size != 0
      end

      def association_scope?(topic_id)
          Topic.find_by_sql([SQL_IS_ASSOCIATION_SCOPE, topic_id]).size != 0
      end

      def topic_map_reifier?(topic_id)
          Topic.find_by_sql([SQL_IS_TOPIC_MAP_REIFIER, topic_id]).size != 0
      end

      def name_reifier?(topic_id)
          Topic.find_by_sql([SQL_IS_NAME_REIFIER, topic_id]).size != 0
      end

      def association_reifier?(topic_id)
          Topic.find_by_sql([SQL_IS_ASSOCIATION_REIFIER, topic_id]).size != 0
      end

      def occurrence_reifier?(topic_id)
          Topic.find_by_sql([SQL_IS_OCCURRENCE_REIFIER, topic_id]).size != 0
      end

      def role_reifier?(topic_id)
          Topic.find_by_sql([SQL_IS_ROLE_REIFIER, topic_id]).size != 0
      end

      def variant_reifier?(topic_id)
          Topic.find_by_sql([SQL_IS_VARIANT_REIFIER, topic_id]).size != 0
      end

      def search_by_name(topic_map, name)
        find_by_sql([SQL_BY_NAME, name, topic_map.id])
      end
      alias search_by_n search_by_name

      def search_by_name_and_variant(topic_map, name)
        find_by_sql([SQL_BY_NAME_AND_VARIANT, name, name, topic_map.id])
      end
      alias search_by_nv search_by_name_and_variant

      def search_by_name_and_variant_and_occurrence(name, topic_map)
        find_by_sql([SQL_BY_NAME_AND_VARIANT_AND_OCCURRENCE,
                    name, name, name, topic_map.id])
      end
      alias search_by_nvo search_by_name_and_variant_and_occurrence

      def find_or_create_by_item_identifier(topic_map, iri)
        topic = Topic.find_by_sql([SQL_TOPIC_ID_BY_II_OR_SI, iri, topic_map.id, iri, topic_map.id]).first
        if topic == nil
          topic = new(:topic_map => topic_map,
                      :item_identifiers=>[ItemIdentifier.new(:href=>iri)])
          topic_map.topics << topic
        end
        return topic
      end
      alias by_ii find_or_create_by_item_identifier

      def find_or_create_by_subject_identifier(topic_map, iri)
        topic = Topic.find_by_sql([SQL_TOPIC_ID_BY_II_OR_SI, iri, topic_map.id, iri, topic_map.id]).first
        if topic == nil
          topic = new(:topic_map => topic_map,
                      :subject_identifiers=>[SubjectIdentifier.new(:href=>iri)])
          topic_map.topics << topic
        end
        return topic
      end
      alias by_si find_or_create_by_subject_identifier

      def find_or_create_by_subject_locator(topic_map, iri)
        topic = find(:first,
          :conditions=>[%{topic_map_id = #{topic_map.id}
            AND subject_locators.href ='#{iri}'}],
          :include =>[:subject_locators])
        if topic == nil
          topic = new(:topic_map => topic_map,
                      :subject_locators=>[SubjectLocator.new(:href=>iri)])
          topic_map.topics << topic
        end
        return topic
      end
      alias by_sl find_or_create_by_subject_locator

      def instance(topic_map)
         by_si(topic_map, PSI[:instance])
      end

      def type(topic_map)
         by_si(topic_map, PSI[:type])
      end

      def type_instance(topic_map)
         by_si(topic_map, PSI[:type_instance])
      end
    end
  end
end
