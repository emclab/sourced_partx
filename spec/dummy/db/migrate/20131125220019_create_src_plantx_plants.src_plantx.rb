# This migration comes from src_plantx (originally 20131028210051)
class CreateSrcPlantxPlants < ActiveRecord::Migration
  def change
    create_table :src_plantx_plants do |t|
      t.string :name
      t.string :short_name
      t.integer :last_updated_by_id
      t.boolean :active, :default => true
      t.text :address
      t.string :phone
      t.string :fax
      t.string :web
      t.text :primary_contact
      t.string :primary_email
      t.string :primary_cell
      t.text :tech_contact
      t.string :tech_email
      t.string :tech_cell
      t.integer :quality_system_id
      t.text :equip
      t.date :src_since
      t.text :main_product
      t.text :tech_ability
      t.text :customer_service
      t.text :production_capacity
      t.string :employee_num
      t.string :revenue
      t.text :sourced_product

      t.timestamps
    end
    
    add_index :src_plantx_plants, :name
    
  end
end
