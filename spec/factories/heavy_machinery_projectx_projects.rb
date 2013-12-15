# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :heavy_machinery_projectx_project, :class => 'HeavyMachineryProjectx::Project' do
    customer_id 1
    status_id 1
    last_updated_by_id 1
    name "My machinery String"
    qty 1
    category_id 1
    tech_spec "My tech Text"
    other_spec "MyText"
    install_address "My address Text"
    construction_requirement "My construction Text"
    turn_over_requirement "My turn over Text"
    project_manager_id 1
    awarded false
    completed false
    cancelled false
    project_num '1223444'
    design_start_date Date.current
    production_start_date Date.current
    install_start_date Date.current
    test_run_date Date.current
    turn_over_date Date.current
    bid_doc_available_date Date.current
    bid_deadline Date.current
    tender_open_date Date.current
  end
end
