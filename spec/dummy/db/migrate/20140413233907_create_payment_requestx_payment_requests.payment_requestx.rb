# This migration comes from payment_requestx (originally 20130908062203)

class CreatePaymentRequestxPaymentRequests < ActiveRecord::Migration
  def change
    create_table :payment_requestx_payment_requests do |t|
      t.date :request_date
      t.string :resource_string
      t.integer :resource_id
      t.decimal :amount, :precision => 10, :scale => 2
      t.string :brief_note
      t.integer :last_updated_by_id
      t.timestamps
      t.boolean :paid, :default => false
      t.integer :paid_by_id
      t.date :paid_date
      t.integer :requested_by_id
      t.boolean :void, :default => false
      t.date :estimated_pay_date
      t.boolean :approved
      t.date :approved_date
      t.string :wfid
      t.string :wf_state
      
    end
    
    add_index :payment_requestx_payment_requests, :resource_id
    add_index :payment_requestx_payment_requests, :resource_string
    add_index :payment_requestx_payment_requests, [:resource_id, :resource_string], :name => :payment_requestx_payment_requests_resource
    add_index :payment_requestx_payment_requests, :wfid
    add_index :payment_requestx_payment_requests, :void
    add_index :payment_requestx_payment_requests, :paid
    add_index :payment_requestx_payment_requests, :wf_state
    add_index :payment_requestx_payment_requests, :requested_by_id
    add_index :payment_requestx_payment_requests, :paid_by_id
  end
end
