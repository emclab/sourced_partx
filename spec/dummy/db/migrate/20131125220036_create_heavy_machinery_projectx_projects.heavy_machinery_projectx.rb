# This migration comes from heavy_machinery_projectx (originally 20131122052644)
class CreateHeavyMachineryProjectxProjects < ActiveRecord::Migration
  def change
    create_table :heavy_machinery_projectx_projects do |t|
      t.integer :customer_id
      t.integer :status_id
      t.integer :last_updated_by_id
      t.string :name
      t.integer :qty
      t.integer :category_id
      t.string :project_num
      t.text :tech_spec
      t.text :other_spec
      t.text :install_address
      t.text :construction_requirement
      t.text :turn_over_requirement
      t.integer :project_manager_id
      t.boolean :awarded, :default => false
      t.boolean :completed, :default => false
      t.boolean :cancelled, :default => false
      t.date :design_start_date
      t.date :production_start_date
      t.date :install_start_date
      t.date :test_run_date
      t.date :turn_over_date
      t.date :bid_doc_available_date
      t.date :bid_deadline
      t.date :tender_open_date
      
      t.timestamps
    end
    
    add_index :heavy_machinery_projectx_projects, :customer_id
    add_index :heavy_machinery_projectx_projects, :status_id
    add_index :heavy_machinery_projectx_projects, :name
    add_index :heavy_machinery_projectx_projects, :completed
    add_index :heavy_machinery_projectx_projects, :cancelled
    add_index :heavy_machinery_projectx_projects, :awarded
    add_index :heavy_machinery_projectx_projects, :category_id
  end
end
