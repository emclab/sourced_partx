module SourcedPartx
  class ApplicationController < ApplicationController
    include Authentify::SessionsHelper
    include Authentify::AuthentifyUtility
    include Authentify::UsersHelper
    include Authentify::UserPrivilegeHelper
    include Commonx::CommonxHelper
    
    before_filter :require_signin
    before_filter :max_pagination 
    before_filter :check_access_right 
    before_filter :load_session_variable, :only => [:new, :edit]  #for parent_record_id & parent_resource in check_access_right
    after_filter :delete_session_variable, :only => [:create, :update]   #for parent_record_id & parent_resource in check_access_right
    
    def search
      @title = params[:controller].camelize.demodulize.tableize.singularize.capitalize + ' Search'  
      @model, @search_stat = Commonx::CommonxHelper.search(params)
      @results_url = 'search_results_' + params[:controller].camelize.demodulize.tableize.downcase + '_path'
      @erb_code = find_config_const('search_params_view')
    end

    def search_results
      @title = params[:controller].camelize.demodulize.tableize.singularize.capitalize + ' Search'
      @s_s_results_details =  Commonx::CommonxHelper.search_results(params, @max_pagination)
      @erb_code = find_config_const(params[:controller].camelize.demodulize.tableize.singularize.downcase + '_index_view', params[:controller].camelize.deconstantize.tableize.singularize.downcase)
    end
    
    def stats
      @title = params[:controller].camelize.demodulize.tableize.singularize.capitalize + ' Stats' 
      @model, @search_stat = Commonx::CommonxHelper.search(params)
      @results_url = 'stats_results_' + params[:controller].camelize.demodulize.tableize.downcase + '_path'
      @erb_code = find_config_const('stats_params_view')
    end

    def stats_results
      @title = params[:controller].camelize.demodulize.tableize.singularize.capitalize + ' Stats' 
      @s_s_results_details =  Commonx::CommonxHelper.search_results(params, @max_pagination)
      @time_frame = eval(@s_s_results_details.time_frame)
      @erb_code = find_config_const(params[:controller].camelize.demodulize.tableize.singularize.downcase + '_index_view', params[:controller].camelize.deconstantize.tableize.singularize.downcase)
    end

    def max_pagination
      @max_pagination = find_config_const('pagination').to_i
    end

  end
end
