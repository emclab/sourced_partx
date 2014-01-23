module SourcedPartx
  include Authentify::AuthentifyUtility
  require 'workflow'
  class Part < ActiveRecord::Base
    include Workflow
    workflow_column :wf_state
    
    workflow do
      #self.to_s = 'EngineName::TableName'    ex, 'InQuotex::Quote'
      wf = Authentify::AuthentifyUtility.find_config_const('quote_wf_pdef', 'in_quotex')
      if Authentify::AuthentifyUtility.find_config_const('wf_pdef_in_config') == 'true' && wf.present?
         #quotes is table name
        eval(wf) if wf.present? && self.wf_state.present 
      else   
        state :fresh do
          event :submit, :transitions_to => :manager_reviewing
        end
        state :manager_reviewing do
          event :manager_approve, :transitions_to => :vp_reviewing
          event :manager_reject, :transitions_to => :fresh
        end
        state :vp_reviewing do
          event :vp_approve, :transitions_to => :approved
          event :vp_reject, :transitions_to => :rejected
          event :vp_rewind, :transitions_to => :fresh
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
                  :wf_comment
    attr_accessible :finish_date, :last_updated_by_id, :name, :part_num, :plant_id, :project_id, :qty, :spec, :src_eng_id, :start_date, :wf_state, 
                    :status_id, :unit, :unit_price, :void, :wfid, :customer_id, :shipping_cost, :tax, :total, :misc_cost, :total, :brief_note, :completed,
                    :requested_by_id,
                    :as => :role_new
    attr_accessible :finish_date, :last_updated_by_id, :name, :part_num, :plant_id, :project_id, :qty, :spec, :src_eng_id, :start_date, :wf_state, 
                    :status_id, :unit, :unit_price, :void, :wfid, :customer_id, :shipping_cost, :tax, :total, :misc_cost, :total, :brief_note, :requested_by_id,
                    :completed,
                    :void_nopudate, :status_name, :src_eng_name, :project_name, :plant_name, :last_updated_by_name, :completed_noupdate, :requested_by_name,
                    :id_noupdate, :wf_comment,
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
    
    #for workflow input validation  
    validate :validate_wf_input_data, :if => 'wf_state.present?' 
    
    def validate_wf_input_data
      wf = Authentify::AuthentifyUtility.find_config_const('validate_part_' + self.wf_state, 'sourced_partx')
      if Authentify::AuthentifyUtility.find_config_const('wf_validate_in_config') == 'true' && wf.present? 
        eval(wf) if wf.present?
      else
        #validate code here
        #case wf_state
        #when 'submit'
        #end
      end
    end
  end
end
