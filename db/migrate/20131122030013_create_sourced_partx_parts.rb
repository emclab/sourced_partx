class CreateSourcedPartxParts < ActiveRecord::Migration
  def change
    create_table :sourced_partx_parts do |t|
      t.string :name
      t.string :part_num
      t.text :part_spec
      t.integer :qty
      t.string :unit
      t.decimal :unit_price, :precision => 10, :scale => 2
      t.integer :plant_id
      t.date :start_date
      t.date :finish_date
      t.boolean :completed, :default => false
      t.integer :src_eng_id
      t.integer :last_updated_by_id      
      t.timestamps
      t.integer :project_id
      t.integer :requested_by_id
      t.integer :customer_id
      t.string :wf_state
      t.integer :status_id
      t.boolean :void, :default => false
      t.text :brief_note
      t.decimal :shipping_cost, :precision => 10, :scale => 2
      t.decimal :tax, :precision => 10, :scale => 2
      t.decimal :misc_cost, :precision => 10, :scale => 2
      t.decimal :total, :precision => 10, :scale => 2
      t.decimal :total_audited, :precision => 10, :scale => 2
    
    end
    
    add_index :sourced_partx_parts, :project_id
    add_index :sourced_partx_parts, :customer_id
    add_index :sourced_partx_parts, :void
    add_index :sourced_partx_parts, :src_eng_id
    add_index :sourced_partx_parts, :plant_id
    add_index :sourced_partx_parts, :wf_state
    add_index :sourced_partx_parts, :name
    add_index :sourced_partx_parts, :status_id
    add_index :sourced_partx_parts, :completed
  end
end
