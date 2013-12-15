module SourcedPartx
  class Part < ActiveRecord::Base
    attr_accessor :void_nopudate, :status_name, :src_eng_name, :project_name, :plant_name, :last_updated_by_name, :requested_by_name, :completed_noupdate
    attr_accessible :comment, :finish_date, :last_updated_by_id, :name, :part_num, :plant_id, :project_id, :qty, :spec, :src_eng_id, :start_date, :state, 
                    :status_id, :unit, :unit_price, :void, :wfid, :customer_id, :shipping_cost, :tax, :total, :misc_cost, :total, :brief_note, :completed,
                    :requested_by_id,
                    :as => :role_new
    attr_accessible :comment, :finish_date, :last_updated_by_id, :name, :part_num, :plant_id, :project_id, :qty, :spec, :src_eng_id, :start_date, :state, 
                    :status_id, :unit, :unit_price, :void, :wfid, :customer_id, :shipping_cost, :tax, :total, :misc_cost, :total, :brief_note, :requested_by_id,
                    :completed,
                    :void_nopudate, :status_name, :src_eng_name, :project_name, :plant_name, :last_updated_by_name, :completed_noupdate, :requested_by_name,
                    :as => :role_update
                    
    belongs_to :project, :class_name => SourcedPartx.project_class.to_s
    belongs_to :src_eng, :class_name => 'Authentify::User'
    belongs_to :plant, :class_name => SourcedPartx.plant_class.to_s
    belongs_to :status, :class_name => 'Commonx::MiscDefinition'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :requested_by, :class_name => 'Authentify::User'
    belongs_to :customer, :class_name => SourcedPartx.customer_class.to_s

    validates :project_id, :plant_id, :status_id, :qty, :requested_by_id, :customer_id, :presence => true,
                           :numericality => {:greater_than => 0, :only_integer => true}
    validates :unit_price, :total, :presence => true, :numericality => { :greater_than => 0 }
    validates :name, :presence => true, :uniqueness => {:scope => :project_id, :case_sensitive => false, :message => I18n.t('Duplicate Sourcing Part Name') }
    validates_presence_of :spec, :unit 
    
  end
end
