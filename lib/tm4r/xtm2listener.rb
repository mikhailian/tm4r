require 'rexml/document'
require 'rexml/parsers/sax2parser'
require 'rexml/sax2listener'

module TM4R
  class XTM2Listener
  attr_reader :path, :stack
    include REXML::SAX2Listener

    def initialize(topic_map,options={})
      @topic_map = topic_map
      @topic_map.save
      @stack = []
      @stack.push @topic_map
      @path=[]
      @counter = 1000
    end

    def make_iri(fragment)
      if fragment.first == '#'
        return @topic_map.base + fragment
      else
        return fragment
      end
    end

    public
    def start_element(uri, name, qname, attrs)
      return unless uri == PSI[:XTMxx]
      case name
      when "topicMap"
      when "topic"
        reload_topic_map # reload the topic map object if needed
        iri = @topic_map.base + "#" + attrs['id']
        @stack.push  Topic.by_ii(@topic_map,iri)
      when "instanceOf"
        @stack.push  Association.new
        @stack.last.type = Topic.by_si(@topic_map,PSI[:type_instance])
      when "name"
        @stack.push Name.new
      when "topicRef"
        case @path.last
        when "instanceOf"
          association = @stack.pop
          role = Role.new(:player=>@stack.last)
          role.type = Topic.instance(@topic_map) # AR reserved words suck
          association.roles << role
          role = Role.new(:player=> Topic.by_ii(@topic_map,make_iri(attrs['href'])))
          role.type = Topic.type(@topic_map) # AR reserved words suck even more
          association.roles << role
          @stack.push association
        when "scope", "type", "role"
          @stack.push Topic.by_ii(@topic_map,make_iri(attrs['href']))
        end
      when "role"
        @stack.push Role.new
      when "association"
        reload_topic_map # reload the topic map object if needed
        @stack.push Association.new
      when "value"
      when "occurrence"
        @stack.push Occurrence.new
      when "variant"
        @stack.push Variant.new
      when "resourceData" # TODO improve storing of anyType later
        if  attrs['datatype']
          @stack.last.datatype = attrs['datatype']
        else 
          @stack.last.datatype = PSI[:anyType]
        end
      when "resourceRef"
        @stack.last.datatype = PSI[:anyURI]
        @stack.last.value = attrs['href']
      when "itemIdentity"
        @stack.last.item_identifiers << ItemIdentifier.new(:href=>make_iri(attrs['href']))
      when "subjectLocator"
        @stack.last.subject_locators << SubjectLocator.new(:href=>make_iri(attrs['href']))
      when "subjectIdentifier"
        @stack.last.subject_identifiers << SubjectIdentifier.new(:href=>make_iri(attrs['href']))
      end
      if attrs['reifier']
        @stack.last.reifier = Topic.by_ii(@topic_map,make_iri(attrs['reifier']))
      end
      @path.push name
    end

    def end_element(uri, name, qname)
      return unless uri == PSI[:XTMxx]
      @path.pop
      case name
      when "topicMap"
        @topic_map.save # resave the topic map after import is finished.
      when "topic"
        @topic_map.topics << @stack.pop
      when "instanceOf", "association"
        association = @stack.pop
        @topic_map.associations << association
      when "type"
        type = @stack.pop
        @stack.last.type = type
      when "role"
        role = @stack.pop
        @stack.last.roles << role
      when "name"
        name = @stack.pop
        @stack.last.names << name
      when "occurrence"
        occurrence = @stack.pop
        @stack.last.occurrences << occurrence
      when "variant"
        variant = @stack.pop
        @stack.last.variants << variant
      when "value", "resourceRef", "resourceData" "itemIdentity", "subjectLocator", "subjectIdentifier"
      when "topicRef"
        case @path.last
        when "scope" 
          scope = Scope.new(:topic=>@stack.pop)
          @stack.last.scopes << scope
        when "role"
          player = @stack.pop
          @stack.last.player = player
        end
      end
    end

    def characters(text)
      return if text.empty?
      case @path.last
      when "value", "resourceData"
        if @stack.last.value
          @stack.last.value += text
        else
          @stack.last.value = text
        end
      end
    end

    private
    def reload_topic_map
      @counter -=1
      if @counter == 0
        @topic_map.clear_aggregation_cache
        @topic_map.clear_association_cache
        @counter = 1000
      end
    end

  end
end
