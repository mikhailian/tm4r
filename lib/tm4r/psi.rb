module TM4R
  PSI = {}
  PSI[:type_instance] = "http://psi.topicmaps.org/iso13250/model/type-instance"
  PSI[:type] = "http://psi.topicmaps.org/iso13250/model/type"
  PSI[:instance] = "http://psi.topicmaps.org/iso13250/model/instance"

  PSI[:supertype_subtype] = "http://psi.topicmaps.org/iso13250/model/supertype-subtype"
  PSI[:supertype] = "http://psi.topicmaps.org/iso13250/model/supertype"
  PSI[:subtype] = "http://psi.topicmaps.org/iso13250/model/subtype"

  PSI[:sort] = "http://psi.topicmaps.org/iso13250/model/sort"

  PSI[:topic_name] = "http://psi.topicmaps.org/iso13250/model/topic-name"

  PSI[:string] = "http://www.w3.org/2001/XMLSchema#string"
  PSI[:anyURI] = "http://www.w3.org/2001/XMLSchema#anyURI"
  PSI[:anyType] = "http://www.w3.org/2001/XMLSchema#anyType"
  PSI[:base64Binary] = "http://www.w3.org/2001/XMLSchema#base64Binary"
  PSI[:date] = "http://www.w3.org/2001/XMLSchema#date"

  PSI[:XTMxx] = "http://www.topicmaps.org/xtm/"
  PSI[:XS] = "http://www.w3.org/2001/XMLSchema"
  PSI[:DC] = "http://purl.org/dc/elements/1.1/"

  PSI[:XTM] = "http://psi.topicmaps.org/iso13250/glossary/XTM"
  PSI[:association] = "http://psi.topicmaps.org/iso13250/glossary/association"
  PSI[:association_role] = "http://psi.topicmaps.org/iso13250/glossary/association-role"
  PSI[:association_role_type] = "http://psi.topicmaps.org/iso13250/glossary/association-role-type"
  PSI[:association_type] = "http://psi.topicmaps.org/iso13250/glossary/association-type"
  PSI[:information_resource] = "http://psi.topicmaps.org/iso13250/glossary/information-resource"
  PSI[:item_identifier] = "http://psi.topicmaps.org/iso13250/glossary/item-identifier"
  PSI[:locator] = "http://psi.topicmaps.org/iso13250/glossary/locator"
  PSI[:merging] = "http://psi.topicmaps.org/iso13250/glossary/merging"
  PSI[:occurrence] = "http://psi.topicmaps.org/iso13250/glossary/occurrence"
  PSI[:occurrence_type] = "http://psi.topicmaps.org/iso13250/glossary/occurrence-type"
  PSI[:reification] = "http://psi.topicmaps.org/iso13250/glossary/reification"
  PSI[:scope] = "http://psi.topicmaps.org/iso13250/glossary/scope"
  PSI[:statement] = "http://psi.topicmaps.org/iso13250/glossary/statement"
  PSI[:subject] = "http://psi.topicmaps.org/iso13250/glossary/subject"
  PSI[:subject_identifier] = "http://psi.topicmaps.org/iso13250/glossary/subject-identifier"
  PSI[:subject_indicator] = "http://psi.topicmaps.org/iso13250/glossary/subject-indicator"
  PSI[:subject_locator] = "http://psi.topicmaps.org/iso13250/glossary/subject-locator"
  PSI[:topic] = "http://psi.topicmaps.org/iso13250/glossary/topic"
  PSI[:topic_map] = "http://psi.topicmaps.org/iso13250/glossary/topic-map"
  PSI[:topic_map_construct] = "http://psi.topicmaps.org/iso13250/glossary/topic-map-construct"
  PSI[:Topic_Maps] = "http://psi.topicmaps.org/iso13250/glossary/Topic-Maps"
  PSI[:topic_name] = "http://psi.topicmaps.org/iso13250/glossary/topic-name"
  PSI[:topic_name_type] = "http://psi.topicmaps.org/iso13250/glossary/topic-name-type"
  PSI[:topic_type] = "http://psi.topicmaps.org/iso13250/glossary/topic-type"
  PSI[:unconstrained_scope] = "http://psi.topicmaps.org/iso13250/glossary/unconstrained-scope"
  PSI[:variant_name] = "http://psi.topicmaps.org/iso13250/glossary/variant-name"

  PSI1 = {}
  PSI1[:XTM] = "http://www.topicmaps.org/xtm/1.0/core.xtm"
  PSI1[:topic] = "http://www.topicmaps.org/xtm/1.0/core.xtm#topic"
  PSI1[:association] = "http://www.topicmaps.org/xtm/1.0/core.xtm#association"
  PSI1[:occurrence] = "http://www.topicmaps.org/xtm/1.0/core.xtm#occurrence"
  PSI1[:class_instance] = "http://www.topicmaps.org/xtm/1.0/core.xtm#class-instance"
  PSI1[:class] = "http://www.topicmaps.org/xtm/1.0/core.xtm#class"
  PSI1[:instance] = "http://www.topicmaps.org/xtm/1.0/core.xtm#instance"
  PSI1[:superclass_subclass] = "http://www.topicmaps.org/xtm/1.0/core.xtm#superclass-subclass"
  PSI1[:superclass] = "http://www.topicmaps.org/xtm/1.0/core.xtm#superclass"
  PSI1[:subclass] = "http://www.topicmaps.org/xtm/1.0/core.xtm#subclass"
  PSI1[:sort] = "http://www.topicmaps.org/xtm/1.0/core.xtm#sort"
  PSI1[:display] = "http://www.topicmaps.org/xtm/1.0/core.xtm#display"

  PREFIX = {}
  PREFIX[:tm] = "http://psi.topicmaps.org/iso13250/model/" # This is the namespace for the concepts defined by TMDM.
  PREFIX[:glossary] = "http://psi.topicmaps.org/iso13250/glossary/"
  PREFIX[:xsd] = "http://www.w3.org/2001/XMLSchema#" # This is the namespace for the XML Schema Datatypes.
  PREFIX[:tmql] = "http://psi.topicmaps.org/tmql/1.0/" # Under this prefix the concepts of TMQL itself are located.
  PREFIX[:fn] = "http://psi.topicmaps.org/tmql/1.0/functions"  # Under this prefix user-callable functions of the predefined TMQL environment are located.
  PREFIX[:xtm1] = "http://www.topicmaps.org/xtm/1.0/core.xtm#"
end
