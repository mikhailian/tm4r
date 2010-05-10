require 'builder'

module TM4R
  class TopicMap < Reifiable


    # item identifiers are not rel
     def to_xtm2(out)
       type_shortcuts ={}

        x = Builder::XmlMarkup.new(:target => out, :indent => 2)
        x.instruct!
        attrs = {:xmlns=>'http://www.topicmaps.org/xtm/', :version=>'2.0'}
        reifier = Topic.first(:conditions=>{
          :reified_id=>self.id,
          :reified_type=>self.class.to_s})
        attrs['reifier'] = rel(reifier.item_identifiers.first.href) unless reifier.nil?
        x.topicMap(attrs){
          topics.each{|topic|
            attrs.clear
            iis = topic.item_identifiers
            attrs['id'] = iis.any? ? iis.shift.href.split('#').last : '_' + topic.id.to_s
            x.topic(attrs) {
              topic.item_identifiers.each{|ii|
                x.itemIdentity(:href=> rel(ii.href))
              }
              topic.subject_locators.each{|sl|
                x.subjectLocator(:href=> sl.href)
              }
              topic.subject_identifiers.each{|si|
                x.subjectLocator(:href=> si.href)
              }
              x.instanceOf{
                topic.types.each {|type|
                  iis = type.item_identifiers
                  id = iis.any? ? rel(iis.shift.href) : '#_' + type.id.to_s
                  x.topicRef(:href=>id)
                }
              } unless topic.types.empty?
              topic.names.each{|name|
                attrs.clear
                reifier = Topic.first(:conditions=>{
                  :reified_id=>name.id,
                  :reified_type=>name.class.to_s})
                attrs['reifier'] = rel(reifier.item_identifiers.first.href) unless reifier.nil?
                x.name(attrs){
                  name.item_identifiers.each{|ii|
                    x.itemIdentity(:href=> rel(ii.href))
                  }
                  x.type{
                    iis = name.type.item_identifiers
                    id = iis.any? ? rel(iis.shift.href) : '#_' + name.type.id.to_s
                    x.topicRef(:href=>id)
                  } unless name.type.nil?
                  x.scope{
                    name.scopes.each{|scope|
                    iis = scope.topic.item_identifiers
                    id = iis.any? ? rel(iis.shift.href) : '#_' + scope.topic.id.to_s
                      x.topicRef(:href=>id)
                    }
                  } unless name.scopes.empty?
                  x.value name.value
                  name.variants.each{|variant|
                    attrs.clear
                    reifier = Topic.first(:conditions=>{
                      :reified_id=>variant.id,
                      :reified_type=>variant.class.to_s})
                    attrs['reifier'] = rel(reifier.item_identifiers.first.href) unless reifier.nil?
                    x.variant(attrs){
                      variant.item_identifiers.each{|ii|
                        x.itemIdentity(:href=> rel(ii.href))
                      }
                      x.scope{
                        variant.scopes.each{|scope|
                        iis = scope.topic.item_identifiers
                        id = iis.any? ? rel(iis.shift.href) : '#_' + scope.topic.id.to_s
                          x.topicRef(:href=>id)
                        }
                      } unless variant.scopes.empty?
                      if variant.datatype == PSI[:anyURI]
                        x.resourceRef(:href=>variant.value)
                      else
                        x.resourceData(variant.value, :datatype=>variant.datatype)
                      end
                    }
                  }
                }
              }
              topic.occurrences.each{|occurrence|
                attrs.clear
                reifier = Topic.first(:conditions=>{
                  :reified_id=>occurrence.id,
                  :reified_type=>occurrence.class.to_s})
                attrs['reifier'] = rel(reifier.item_identifiers.first.href) unless reifier.nil?
                x.occurrence(attrs){
                  occurrence.item_identifiers.each{|ii|
                    x.itemIdentity(:href=> rel(ii.href))
                  }
                  x.type{
                    iis = occurrence.type.item_identifiers
                    id = iis.any? ? rel(iis.shift.href) : '#_' + occurrence.type.id.to_s
                    x.topicRef(:href=>id)
                  }
                  x.scope{
                    occurrence.scopes.each{|scope|
                      iis = scope.topic.item_identifiers
                      id = iis.any? ? rel(iis.shift.href) : '#_' + scope.topic.id.to_s
                      x.topicRef(:href=>id)
                    }
                  } unless occurrence.scopes.empty?
                  if occurrence.datatype == PSI[:anyURI]
                    x.resourceRef(:href=>occurrence.value)
                  else
                    x.resourceData(occurrence.value, :datatype=>occurrence.datatype)
                  end
                }
              }
            }
          }
          associations.each{|association|
            attrs.clear
            reifier = Topic.first(:conditions=>{
              :reified_id=>association.id,
              :reified_type=>association.class.to_s})
            attrs['reifier'] = rel(reifier.item_identifiers.first.href) unless reifier.nil?
            x.association(attrs){
              association.item_identifiers.each{|ii|
                x.itemIdentity(:href=> rel(ii.href))
              }
              x.type{
                iis = association.type.item_identifiers
                id = iis.any? ? rel(iis.shift.href) : '#_' + association.type.id.to_s
                x.topicRef(:href=>id)
              }
              x.scope{
                association.scopes.each{|scope|
                  iis = scope.topic.item_identifiers
                  id = iis.any? ? rel(iis.shift.href) : '#_' + scope.topic.id.to_s
                  x.topicRef(:href=>id)
                }
              } unless association.scopes.empty?
              association.roles.each{|role|
                attrs.clear
                reifier = Topic.first(:conditions=>{
                  :reified_id=>role.id,
                  :reified_type=>role.class.to_s})
                attrs['reifier'] = reifier.item_identifiers.first.href unless reifier.nil?
                x.role(attrs){
                  role.item_identifiers.each{|ii|
                    x.itemIdentity(:href=> rel(ii.href))
                  }
                  x.type{
                    iis = role.type.item_identifiers
                    id = iis.any? ? rel(iis.first.href) : '#_' + role.type.id.to_s
                    x.topicRef(:href=>id)
                  }
                  iis = role.player.item_identifiers
                  id = iis.any? ? rel(iis.shift.href) : '#_' + role.player.id.to_s
                  x.topicRef(:href=>id)
                }
              }
            }
          }
        }
     end

    private
    def rel(iri)
      iri.sub(self.base, '')
    end
  end
end
