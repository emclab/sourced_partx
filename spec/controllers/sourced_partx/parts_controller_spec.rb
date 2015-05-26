require 'rails_helper'

module SourcedPartx
  RSpec.describe PartsController, type: :controller do
    routes {SourcedPartx::Engine.routes}
    before(:each) do
      expect(controller).to receive(:require_signin)
      expect(controller).to receive(:require_employee)
           
    end
    
    before(:each) do
      wf = "def submit
          wf_common_action('fresh', 'reviewing', 'submit')
        end   
        def approve
          wf_common_action('reviewing', 'approved', 'approve')
        end    
        def reject
          wf_common_action('reviewing', 'rejected', 'reject')
        end
        def rewind
          wf_common_action('reviewing', 'fresh', 'rewind')
        end
        def complete
          wf_common_action('approved', 'completed', 'complete')
        end"
      FactoryGirl.create(:engine_config, :engine_name => 'sourced_partx', :engine_version => nil, :argument_name => 'part_wf_action_def', :argument_value => wf)
      FactoryGirl.create(:engine_config, :engine_name => 'sourced_partx', :engine_version => nil, :argument_name => 'part_wf_final_state_string', :argument_value => 'completed, rejected')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_pdef_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_route_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_validate_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_list_open_process_in_day', :argument_value => '45')
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
      
      @pur_sta = FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'part_sourcing_status')
      @cust = FactoryGirl.create(:kustomerx_customer) 
      @proj = FactoryGirl.create(:heavy_machinery_projectx_project, :customer_id => @cust.id) 
      
      session[:user_role_ids] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id).user_role_ids
    end
    
    render_views
    
    describe "GET 'index'" do
      it "returns parts" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'sourced_partx_parts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "SourcedPartx::Part.where(:void => false).order('created_at DESC')")
        session[:user_id] = @u.id
        task = FactoryGirl.create(:sourced_partx_part, :project_id => @proj.id)
        task1 = FactoryGirl.create(:sourced_partx_part, :project_id => @proj.id, :name => 'a new task')
        get 'index'
        expect(assigns[:parts]).to match_array([task, task1])
      end
      
      it "should only return the part for a project_id" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'sourced_partx_parts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "SourcedPartx::Part.where(:void => false).order('created_at DESC')")
        session[:user_id] = @u.id
        task = FactoryGirl.create(:sourced_partx_part, :project_id => @proj.id)
        task1 = FactoryGirl.create(:sourced_partx_part, :project_id => @proj.id + 1, :name => 'a new task')
        get 'index', {:project_id => @proj.id}
        expect(assigns[:parts]).to match_array([task])
      end
      
      it "should only return the part for the customer_id" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'sourced_partx_parts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "SourcedPartx::Part.where(:void => false).order('created_at DESC')")
        session[:user_id] = @u.id
        task = FactoryGirl.create(:sourced_partx_part, :project_id => @proj.id, :void => true)
        task1 = FactoryGirl.create(:sourced_partx_part, :project_id => @proj.id, :name => 'a new task', :customer_id => @cust.id)
        get 'index', {:project_id => @proj.id, :customer_id => @cust.id}
        expect(assigns[:parts]).to match_array([task1])
      end
            
    end
  
    describe "GET 'new'" do
      it "returns bring up new page" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'sourced_partx_parts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        get 'new', { :project_id => @proj.id}
        expect(response).to be_success
      end
      
    end
  
    describe "GET 'create'" do
      it "should create and redirect after successful creation" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'sourced_partx_parts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        task = FactoryGirl.attributes_for(:sourced_partx_part, :project_id => @proj.id )  
        get 'create', {:part => task, :project_id => @proj.id}
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render 'new' if data error" do        
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'sourced_partx_parts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        task = FactoryGirl.attributes_for(:sourced_partx_part, :project_id => @proj.id, :name => nil)
        get 'create', {:part => task, :project_id => @proj.id}
        expect(response).to render_template('new')
      end
    end
  
    describe "GET 'edit'" do
      it "returns edit page" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'sourced_partx_parts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        task = FactoryGirl.create(:sourced_partx_part, :project_id => @proj.id)
        get 'edit', {:id => task.id}
        expect(response).to be_success
      end
      
      it "should redirect to previous page for an open process" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'sourced_partx_parts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        task = FactoryGirl.create(:sourced_partx_part, :project_id => @proj.id, :wf_state => 'vp_reviewing')  
        get 'edit', {:id => task.id}
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO Update. Record Being Processed!")
      end
    end
  
    describe "GET 'update'" do
      it "should return success and redirect" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'sourced_partx_parts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        task = FactoryGirl.create(:sourced_partx_part, :project_id => @proj.id)
        get 'update', {:id => task.id, :part => {:name => 'new name'}}
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render edit with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'sourced_partx_parts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        task = FactoryGirl.create(:sourced_partx_part, :project_id => @proj.id)
        get 'update', {:id => task.id, :part => {:name => ''}}
        expect(response).to render_template('edit')
      end
    end
  
    describe "GET 'show'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'sourced_partx_parts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.requested_by_id == session[:user_id]")
        session[:user_id] = @u.id
        plant = FactoryGirl.create(:src_plantx_plant)
        status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'part_sourcing_status', :name => 'something new')
        task = FactoryGirl.create(:sourced_partx_part, :project_id => @proj.id,  :src_eng_id => @u.id, :plant_id => plant.id, :status_id => status.id)
        get 'show', {:id => task.id}
        expect(response).to be_success
      end
    end
    
    describe "GET 'list open process" do
      it "return open process only" do
        user_access = FactoryGirl.create(:user_access, :action => 'list_open_process', :resource =>'sourced_partx_parts', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "SourcedPartx::Part.where(:void => false).order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:sourced_partx_part, :project_id => @proj.id, :created_at => 50.days.ago, :wf_state => 'rejected')
        task1 = FactoryGirl.create(:sourced_partx_part, :project_id => @proj.id, :name => 'a new task', :wf_state => 'rejected')
        task2 = FactoryGirl.create(:sourced_partx_part, :project_id => @proj.id, :name => 'a new task1', :wf_state => 'manager_reviewing')
        task3 = FactoryGirl.create(:sourced_partx_part, :project_id => @proj.id, :name => 'a new task23', :wf_state => 'vp_reviewing')
        get 'list_open_process'
        expect(assigns(:parts)).to match_array([task3, task2])  #wf_state can't be what was defined.
      end
    end
    
  end
end
