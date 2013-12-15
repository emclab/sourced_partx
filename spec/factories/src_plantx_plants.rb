# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :src_plantx_plant, :class => 'SrcPlantx::Plant' do
    name "My name String"
    short_name "My short String"
    last_updated_by_id 1
    active true
    address "MyText"
    phone "MyString"
    fax "MyString"
    primary_contact "MyText"
    primary_cell "MyString"
    tech_contact "MyText"
    tech_cell "MyString"
    quality_system_id 1
    equip "MyText"
    src_since "2013-10-28"
    main_product "My product Text"
    tech_ability "Mytech ability Text"
    customer_service "MyText"
    production_capacity "MyText"
    employee_num "MyString"
    revenue "MyString"
    sourced_product "MyText"
    primary_email 'a@b.com'
    tech_email 'bc@example.com'
    web 'web'
  end
end
