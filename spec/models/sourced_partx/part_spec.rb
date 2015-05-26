require 'rails_helper'

module SourcedPartx
  RSpec.describe Part, type: :model do
    it "should be OK" do
      c = FactoryGirl.build(:sourced_partx_part)
      expect(c).to be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:sourced_partx_part, :name => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject nil unit" do
      c = FactoryGirl.build(:sourced_partx_part, :unit => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject nil part_spec" do
      c = FactoryGirl.build(:sourced_partx_part, :part_spec => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject dup name" do
      c = FactoryGirl.create(:sourced_partx_part, :name => "nil")
      c1 = FactoryGirl.build(:sourced_partx_part, :name => "Nil", :project_id => c.project_id)
      expect(c1).not_to be_valid
    end
    
    it "should reject 0 qty" do
      c = FactoryGirl.build(:sourced_partx_part, :qty => 0)
      expect(c).not_to be_valid
    end
    
    it "should reject 0 project_id" do
      c = FactoryGirl.build(:sourced_partx_part, :project_id => 0)
      expect(c).not_to be_valid
    end
    
    #it "should reject nil status_id" do
     # c = FactoryGirl.build(:sourced_partx_part, :status_id => nil)
     # expect(c).not_to be_valid
    #end
    
    it "should reject 0 customer_id" do
      c = FactoryGirl.build(:sourced_partx_part, :customer_id => 0)
      expect(c).not_to be_valid
    end
    
    it "should reject 0 requested_by_id" do
      c = FactoryGirl.build(:sourced_partx_part, :requested_by_id => 0)
      expect(c).not_to be_valid
    end
    
    it "should take 0 unit_price" do
      c = FactoryGirl.build(:sourced_partx_part, :unit_price => 0)
      expect(c).to be_valid
    end
    
    it "should take negative unit_price" do
      c = FactoryGirl.build(:sourced_partx_part, :unit_price => -1)
      expect(c).to be_valid
    end
    
    it "should reject non numerical unit_price" do
      c = FactoryGirl.build(:sourced_partx_part, :unit_price => '-a')
      expect(c).not_to be_valid
    end
    
    it "should reject nil unit_price" do
      c = FactoryGirl.build(:sourced_partx_part, :unit_price => nil)
      expect(c).to be_valid
    end
   
    it "should take negative total" do
      c = FactoryGirl.build(:sourced_partx_part, :total => -10)
      expect(c).to be_valid
    end
    
    #it "should reject nil total" do
    #  c = FactoryGirl.build(:sourced_partx_part, :total => nil)
    #  expect(c).not_to be_valid
    #end
    
    #it "should reject nil src plant id" do
    #  c = FactoryGirl.build(:sourced_partx_part, :plant_id => nil)
    #  expect(c).not_to be_valid
    #end    
  end
end
