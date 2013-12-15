require 'spec_helper'

describe "LinkTests" do
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
         'mini-link'    => mini_btn +  'btn btn-link'
        }
    before(:each) do
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
      user_access = FactoryGirl.create(:user_access, :action => 'create_part_sourcing', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")
      
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
      task = FactoryGirl.create(:sourced_partx_part, :project_id => @proj.id, :plant_id => @plant.id)
      visit parts_path
      #save_and_open_page
      page.should have_content('Sourcing Parts')
      click_link 'Edit'
      page.should have_content('Edit Sourcing Part')
      #save_and_open_page
      visit parts_path
      click_link task.id.to_s
      save_and_open_page
      page.should have_content('Sourcing Part Info')
      click_link 'New Log'
      #save_and_open_page
      page.should have_content('Log')
      
      visit new_part_path(:project_id => @proj.id)
      #save_and_open_page
      page.should have_content('New Sourcing Part')
    end
    
  end
end
