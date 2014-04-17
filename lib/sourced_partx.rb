require "sourced_partx/engine"

module SourcedPartx
  mattr_accessor :project_class, :plant_class, :customer_class, :show_project_path, :show_customer_path, :show_plant_path, :index_payment_request_path, 
                 :payment_request_resource, :index_payment_request_sourced_partx_path
  
  def self.project_class
    @@project_class.constantize
  end
  
  def self.supplier_class
    @@plant_class.constantize
  end
  
  def self.customer_class
    @@customer_class.constantize
  end
end
