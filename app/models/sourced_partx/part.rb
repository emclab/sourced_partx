module SourcedPartx
  include Authentify::AuthentifyUtility
  require 'workflow'
  class Part < ActiveRecord::Base
    include Workflow
    workflow_column :wf_state
    
    workflow do
      #self.to_s = 'EngineName::TableName'    ex, 'InQuotex::Quote'
      wf = Authentify::AuthentifyUtility.find_config_const('part_wf_pdef', 'sourced_partx')
      if Authentify::AuthentifyUtility.find_config_const('wf_pdef_in_config') == 'true' && wf.present?
         #quotes is table name
        eval(wf) # if wf.present? #&& self.wf_state.present? 
      elsif Rails.env.test?  
        state :initial_state do
          event :submit, :transitions_to => :manager_reviewing
        end
        state :manager_reviewing do
          event :manager_approve, :transitions_to => :vp_reviewing
          event :manager_reject, :transitions_to => :fresh
        end
        state :vp_reviewing do
          event :vp_approve, :transitions_to => :approved
          event :vp_reject, :transitions_to => :rejected
          event :vp_rewind, :transitions_to => :initial_state
        end
        state :approved do
          event :stamp, :transitions_to => :stamped
        end
        state :stamped do
          event :complete, :transitions_to => :completed
        end
        state :completed
        state :rejected
      end
    end
    
    attr_accessor :void_nopudate, :status_name, :src_eng_name, :project_name, :plant_name, :last_updated_by_name, :requested_by_name, :completed_noupdate, :id_noupdate, 
                  :wf_comment, :customer_name, :wf_state_noupdate, :wf_event
=begin
    attr_accessible :finish_date, :last_updated_by_id, :name, :part_num, :plant_id, :project_id, :qty, :part_spec, :src_eng_id, :start_date, :wf_state, 
                    :status_id, :unit, :unit_price, :void, :customer_id, :shipping_cost, :tax, :total, :misc_cost, :total, :brief_note, :completed,
                    :requested_by_id, :approved, :approved_date, :approved_by_id,
                    :customer_name, :project_name,
                    :as => :role_new
    attr_accessible :finish_date, :last_updated_by_id, :name, :part_num, :plant_id, :project_id, :qty, :part_spec, :src_eng_id, :start_date, :wf_state, 
                    :status_id, :unit, :unit_price, :void, :customer_id, :shipping_cost, :tax, :total, :misc_cost, :total, :brief_note, :requested_by_id,
                    :completed, :total_audited, :approved, :approved_date, :approved_by_id,
                    :void_nopudate, :status_name, :src_eng_name, :project_name, :plant_name, :last_updated_by_name, :completed_noupdate, :requested_by_name,
                    :id_noupdate, :wf_comment, :customer_name, :wf_state_noupdate, 
                    :as => :role_update
    
    attr_accessor   :project_id_s, :start_date_s, :end_date_s, :purchasing_id_s, :customer_id_s, :eng_id_s, :name_s, :part_spec_s, :part_num_s, 
                    :plant_id_s, :delivered_s, :time_frame_s, :keyword_s, :status_id_s, :requested_by_id_s, :manufacturer_id_s

    attr_accessible :project_id_s, :start_date_s, :end_date_s, :purchasing_id_s, :customer_id_s, :eng_id_s, :status_id_s, :manufacturer_id_s,
                    :plant_id_s, :delivered_s, :keyword_s, :requested_by_id_s, :name_s, :part_spec_s, :part_num_s, :as => :role_search_stats
=end
                                    
    belongs_to :project, :class_name => SourcedPartx.project_class.to_s
    belongs_to :src_eng, :class_name => 'Authentify::User'
    belongs_to :plant, :class_name => SourcedPartx.plant_class.to_s
    belongs_to :status, :class_name => 'Commonx::MiscDefinition'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :requested_by, :class_name => 'Authentify::User'
    belongs_to :approved_by, :class_name => 'Authentify::User'
    belongs_to :customer, :class_name => SourcedPartx.customer_class.to_s

    validates :name, :presence => true, :uniqueness => {:scope => :project_id, :case_sensitive => false, :message => I18n.t('Duplicate Sourcing Part Name') }
    validates :part_spec, :unit, :presence => true 
    validates :project_id, :qty, :requested_by_id, :customer_id, :presence => true,
                           :numericality => {:greater_than => 0, :only_integer => true}
    validates :unit_price, :numericality => {:if => 'unit_price.present?'}
    validates :total, :numericality => { :if => 'total.present?' } 
    validates :approved_by_id, :numericality => {:greater_than => 0, :only_integer => true}, :if => 'approved_by_id.present?'
    validate :dynamic_validate
    
    #for workflow input validation  
    validate :validate_wf_input_data, :if => 'wf_state.present?' 
    
    def validate_wf_input_data
      wf = Authentify::AuthentifyUtility.find_config_const('validate_part_' + self.wf_event, 'sourced_partx') if self.wf_event.present?
      if Authentify::AuthentifyUtility.find_config_const('wf_validate_in_config') == 'true' && wf.present? 
        eval(wf) 
      end
    end
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate', 'sourced_partx')
      eval(wf) if wf.present?
    end
    
  end
end
