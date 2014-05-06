# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sourced_partx_part, :class => 'SourcedPartx::Part' do
    name "MyString"
    part_num "MyString"
    part_spec "MyText"
    qty 1
    unit "MyString"
    #unit_price "9.99"
    #plant_id 1
    start_date "2013-11-21"
    finish_date "2013-11-21"
    src_eng_id 1
    project_id 1
    last_updated_by_id 1
    wf_state ""
    #status_id 1
    customer_id 1
    void false
    completed false
    shipping_cost '9.9'
    tax '9'
    misc_cost '9.0'
    #total '29.99'
    brief_note 'my note'
    requested_by_id 1
  end
end
