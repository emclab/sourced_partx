require 'rails_helper'

RSpec.describe "LinkTests", type: :request do
  describe "GET /sourced_partx_link_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link',
         'right-span#'         => '2', 
               'left-span#'         => '6', 
               'offset#'         => '2',
               'form-span#'         => '4'
        }
    before(:each) do
      wf = "def submit
          wf_common_action('fresh', 'reviewing', 'submit')
        end   
        def vp_approve
          wf_common_action('vp_reviewing', 'approved', 'vp_approve')
        end    
        def vp_reject
          wf_common_action('vp_reviewing', 'rejected', 'vp_reject')
        end
        def vp_rewind
          wf_common_action('vp_reviewing', 'fresh', 'vp_rewind')
        end
        def stamp
          wf_common_action('approved', 'stamped', 'stamp')
        end
        def complete
          wf_common_action('stamped', 'completed', 'complete')
        end"
      FactoryGirl.create(:engine_config, :engine_name => 'sourced_partx', :engine_version => nil, :argument_name => 'part_wf_action_def', :argument_value => wf)
      FactoryGirl.create(:engine_config, :engine_name => 'sourced_partx', :engine_version => nil, :argument_name => 'part_wf_final_state_string', :argument_value => 'completed, rejected')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_pdef_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_route_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_validate_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_list_open_process_in_day', :argument_value => '45')
      FactoryGirl.create(:engine_config, :engine_name => 'sourced_partx', :engine_version => nil, :argument_name => 'part_vp_approve_inline', 
                         :argument_value => "<%= f.input :start_date, :label => t('Start Date') , :as => :string %>")
      FactoryGirl.create(:engine_config, :engine_name => 'sourced_partx', :engine_version => nil, :argument_name => 'validate_part_vp_approve', 
                         :argument_value => "errors.add(:start_date, I18n.t('Not be blank')) if start_date.blank?                                             
                                           ")
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      @project_num_time_gen = FactoryGirl.create(:engine_config, :engine_name => 'heavy_machinery_projectx', :engine_version => nil, :argument_name => 'project_num_time_gen', :argument_value => ' HeavyMachineryProjectx::Project.last.nil? ? (Time.now.strftime("%Y%m%d") + "-"  + 112233.to_s + "-" + rand(100..999).to_s) :  (Time.now.strftime("%Y%m%d") + "-"  + (HeavyMachineryProjectx::Project.last.project_num.split("-")[-2].to_i + 555).to_s + "-" + rand(100..999).to_s)')
      engine_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'piece_unit', :argument_value => "set, piece")
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      ua1 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'sourced_partx_parts', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "SourcedPartx::Part.where(:void => false).order('created_at DESC')")
      ua1 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'sourced_partx_parts', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'sourced_partx_parts', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'sourced_partx_parts', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "record.requested_by_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'create_part_sourced', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'event_action', :resource => 'sourced_partx_parts', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'vp_approve', :resource => 'sourced_partx_parts', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'list_open_process', :resource => 'sourced_partx_parts', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "SourcedPartx::Part.where(:void => false).order('created_at DESC')")
      @pur_sta = FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'part_sourcng_status')
      @cust = FactoryGirl.create(:kustomerx_customer) 
      @plant = FactoryGirl.create(:src_plantx_plant)
      @proj = FactoryGirl.create(:heavy_machinery_projectx_project, :customer_id => @cust.id) 
      
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => @u.password
      click_button 'Login'
    end
    it "works! (now write some real specs)" do
      user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'payment_requestx_payment_requests', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "PaymentRequestx::PaymentRequest.where(:void => false).order('created_at DESC')")
      task = FactoryGirl.create(:sourced_partx_part, :project_id => @proj.id, :plant_id => @plant.id)
      visit sourced_partx.parts_path
      save_and_open_page
      expect(page).to have_content('Sourcing Parts')
      click_link 'Edit'
      #save_and_open_page
      expect(page).to have_content('Edit Sourcing Part')  
      fill_in 'part_name', :with => 'new name'
      click_button "Save"
      #bad data
      fill_in 'part_name', :with => ''
      click_button "Save"
      #save_and_open_page
      
      #to payment request
      visit sourced_partx.parts_path
      #save_and_open_page
      click_link 'Payment Requests'
      #save_and_open_page
       
      visit sourced_partx.parts_path
      click_link task.id.to_s
      #save_and_open_page
      expect(page).to have_content('Sourcing Part Info')
      click_link 'New Log'
      #save_and_open_page
      expect(page).to have_content('Log')
      
      visit sourced_partx.new_part_path(:project_id => @proj.id)
      #save_and_open_page
      expect(page).to have_content('New Sourcing Part')
      fill_in 'part_name', :with => 'test'
      fill_in 'part_qty', :with => 3
      fill_in 'part_part_spec', :with => 'spec'
      select('piece', :from => 'part_unit') 
      click_button 'Save'
      
      #with wrong data
      visit sourced_partx.new_part_path(:project_id => @proj.id)
      #save_and_open_page
      expect(page).to have_content('New Sourcing Part')
      fill_in 'part_name', :with => ''
      fill_in 'part_qty', :with => 3
      fill_in 'part_part_spec', :with => 'spec'
      select('piece', :from => 'part_unit') 
      click_button 'Save'
      save_and_open_page

    end 
    
    it "should allow index payment request for subaction sourced_partx" do
      user_access = FactoryGirl.create(:user_access, :action => 'index_sourced_partx', :resource => 'payment_requestx_payment_requests', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "PaymentRequestx::PaymentRequest.where(:void => false, :resource_string => 'sourced_partx/parts').order('created_at DESC')")
      task = FactoryGirl.create(:sourced_partx_part, :project_id => @proj.id, :plant_id => @plant.id)
      visit sourced_partx.parts_path
      click_link 'Payment Requests'
      expect(page).to have_content('Payment Requests')
    end
    
    it "work for workflow" do
      task = FactoryGirl.create(:sourced_partx_part, :project_id => @proj.id, :plant_id => @plant.id, :wf_state => 'vp_reviewing')
      #bad data
      visit sourced_partx.parts_path
      save_and_open_page
      click_link 'Vp Approve'
      save_and_open_page
      fill_in 'part_wf_comment', :with => 'this line tests workflow'
      fill_in 'part_start_date', :with => nil #Date.today
      #save_and_open_page
      click_button 'Save'
      #check
      visit sourced_partx.parts_path
      click_link task.id.to_s
      #save_and_open_page
      expect(page).not_to have_content('this line tests workflow')
      #good data
      visit sourced_partx.parts_path
      save_and_open_page
      click_link 'Vp Approve'
      save_and_open_page
      fill_in 'part_wf_comment', :with => 'this line tests workflow'
      fill_in 'part_start_date', :with => Date.today
      #save_and_open_page
      click_button 'Save'
      #
      visit sourced_partx.parts_path
      #save_and_open_page
      click_link 'Open Process'
      expect(page).to have_content('Parts')
      
      visit sourced_partx.parts_path
      click_link task.id.to_s
      save_and_open_page
      expect(page).to have_content('this line tests workflow')
      expect(page).to have_content(Date.today.to_s.gsub('-', '/'))
    end
    
  end
end
