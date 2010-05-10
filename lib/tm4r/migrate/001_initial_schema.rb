require 'rubygems'
require 'activerecord'

class InitialSchema < ActiveRecord::Migration

  def self.up
    #options = {:options => "ENGINE=InnoDB CHARACTER SET utf8 COLLATE utf8_general_ci"}
    #options = nil

    create_table(:topic_maps) do |t|
      t.column :base, :string, :null => false
    end
    add_index(:topic_maps, :base, :name=>'ndx_topic_maps_base', :unique => true)

    create_table(:topics) do |t|
      t.column :topic_map_id, :integer, :null => false, :references => :topic_maps
      t.column :reified_id, :integer
      t.column :reified_type, :string
    end
    add_index(:topics, [:reified_id, :reified_type], :name=>'ndx_topics_reified', :unique => true)
    add_index(:topics, :topic_map_id, :name=>'ndx_topics_topic_map_id')

    create_table(:associations) do |t|
      t.column :topic_map_id, :integer, :null => false, :references => :topic_maps
      t.column :type_id, :integer, :null => false, :references => :topics
    end
    add_index(:associations, :topic_map_id, :name=>'ndx_associations_topic_map_id')
    add_index(:associations, :type_id, :name=>'ndx_associations_type_id')

    create_table(:roles) do |t|
      t.column :association_id, :integer, :null => false, :references => :topic_maps
      t.column :player_id, :integer, :references => :topics
      t.column :type_id, :integer, :references => :topics
    end
    add_index(:roles, :association_id, :name=>'ndx_roles_association_id')
    add_index(:roles, :player_id, :name=>'ndx_roles_player_id')
    add_index(:roles, :type_id, :name=>'ndx_roles_type_id')

    create_table(:names) do |t|
      t.column :topic_id, :integer, :null => false, :references => :topics
      t.column :type_id, :integer, :references => :topics
      t.column :value, :string
    end
    add_index(:names, :topic_id, :name=>'ndx_names_topic_id')
    add_index(:names, :type_id, :name=>'ndx_names_type_id')

    create_table(:occurrences) do |t|
      t.column :topic_id, :integer, :null => false, :references => :topics
      t.column :type_id, :integer, :null => false, :references => :topics
      t.column :value, :text
      t.column :datatype, :string
    end
    add_index(:occurrences, :topic_id, :name=>'ndx_occurrences_topic_id')
    add_index(:occurrences, :type_id, :name=>'ndx_occurrences_type_id')
    add_index(:occurrences, :datatype, :name=>'ndx_occurrences_datatype')


    create_table(:scopes) do |t|
      t.column :topic_id, :integer, :null => false, :references => :topics
      t.column :scopable_id, :integer, :null => false
      t.column :scopable_type, :string, :null => false
    end
    add_index(:scopes, :topic_id, :name=>'ndx_scopes_topic_id')
    add_index(:scopes, [:scopable_type, :topic_id], :name=>'ndx_scopable_type_topic_id')
    add_index(:scopes, [:scopable_id, :scopable_type], :name=>'ndx_scopable')

    create_table(:variants) do |t|
      t.column :name_id, :integer, :null => false, :references => :names
      t.column :scope_id, :integer, :references => :scopes
      t.column :value, :string
      t.column :datatype, :string
    end
    add_index(:variants, :name_id, :name=>'ndx_variants_name_id')
    add_index(:variants, :scope_id, :name=>'ndx_variants_scope_id')
    add_index(:variants, :datatype, :name=>'ndx_variants_datatype')

    create_table(:item_identifiers) do |t|
      t.column :topic_map_construct_id, :integer, :null => false
      t.column :topic_map_construct_type, :string, :null => false
      t.column :href, :string, :null => false
    end
    add_index(:item_identifiers, [:topic_map_construct_id, :topic_map_construct_type], :name=>'ndx_ii_topic_map_construct')
    add_index(:item_identifiers, :href, :name=>'ndx_ii_href')

    create_table(:subject_identifiers) do |t|
      t.column :topic_id, :integer, :null => false, :references => :topics
      t.column :href, :string, :null => false
    end
    add_index(:subject_identifiers, :topic_id, :name=>'ndx_si_topic_id')
    add_index(:subject_identifiers, :href, :name=>'ndx_si_href')

    create_table(:subject_locators) do |t|
      t.column :topic_id, :integer, :null => false, :references => :topics
      t.column :href, :string, :null => false
    end
    add_index(:subject_locators, :topic_id, :name=>'ndx_sl_topic_id')
    add_index(:subject_locators, :href, :name=>'ndx_sl_href')

    # convert into InnoDB
    # ActiveRecord::Base.connection.tables.reject { |t| t == "schema_info" }.each { |table|
    #   ActiveRecord::Migration::execute("ALTER TABLE `#{table}` TYPE = InnoDB")
    # }

  end

  def self.down
    execute 'SET FOREIGN_KEY_CHECKS = 0'
    drop_table :roles
    drop_table :names
    drop_table :occurrences
    drop_table :variants
    drop_table :item_identifiers
    drop_table :subject_identifiers
    drop_table :subject_locators
    drop_table :scopes
    drop_table :associations
    drop_table :topics
    drop_table :topic_maps
    execute 'SET FOREIGN_KEY_CHECKS = 1'
  end
end


if __FILE__ == $0
  puts "Generating SQLite3 Databse tm4r.sqlite3."
  dbconfig = YAML::load(File.open('database.yaml'))
  ActiveRecord::Base.establish_connection(dbconfig)
  InitialSchema.up
end

