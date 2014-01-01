require_dependency "sourced_partx/application_controller"

module SourcedPartx
  class PartsController < ApplicationController
    before_filter :require_employee
    before_filter :load_parent_record
    
    def index
      @title = 'Sourcing Parts'      
      @parts = params[:sourced_partx_parts][:model_ar_r]
      @parts = @parts.where(:customer_id => @customer.id) if @customer
      @parts = @parts.where(:project_id => @project.id) if @project
      @parts = @parts.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('part_index_view', 'sourced_partx')
    end
  
    def new
      @title = 'New Sourcing Part'
      @part = SourcedPartx::Part.new
    end
  
    def create
      @part = SourcedPartx::Part.new(params[:part], :as => :role_new)
      @part.last_updated_by_id = session[:user_id]
      @part.requested_by_id = session[:user_id]
      if @part.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        @project = SourcedPartx.project_class.find_by_id(params[:part][:project_id]) if params[:part].present? && params[:part][:project_id].present?
        @customer = SourcedPartx.customer_class.find_by_id(params[:part][:customer_id]) if params[:part].present? && params[:part][:customer_id].present?
        flash.now[:error] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = 'Edit Sourcing Part'
      @part = SourcedPartx::Part.find_by_id(params[:id])
    end
  
    def update
      @part = SourcedPartx::Part.find_by_id(params[:id])
      @part.last_updated_by_id = session[:user_id]
      if @part.update_attributes(params[:part], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        flash.now[:error] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
  
    def show
      @title = 'Sourcing Part Info'
      @part = SourcedPartx::Part.find_by_id(params[:id])
      @erb_code = find_config_const('part_show_view', 'sourced_partx')
    end
    
    protected
    def load_parent_record
      @customer = SourcedPartx.customer_class.find_by_id(params[:customer_id]) if params[:customer_id].present?
      @project = SourcedPartx.project_class.find_by_id(params[:project_id]) if params[:project_id].present?
      @customer = SourcedPartx.customer_class.find_by_id(@project.customer_id) if params[:project_id].present?
      @project = SourcedPartx.project_class.find_by_id(SourcedPartx::Part.find_by_id(params[:id]).project_id) if params[:id].present?
      @customer = SourcedPartx.customer_class.find_by_id(SourcedPartx::Part.find_by_id(params[:id]).customer_id) if params[:id].present?
    end
    
  end
end
