SourcedPartx.project_class = 'HeavyMachineryProjectx::Project'
SourcedPartx.customer_class = 'Kustomerx::Customer'
SourcedPartx.plant_class = 'SrcPlantx::Plant'
SourcedPartx.show_project_path = 'heavy_machinery_projectx.project_path(r.project_id)'
SourcedPartx.show_customer_path = 'kustomerx.customer_path(r.customer_id)'
SourcedPartx.show_plant_path = 'src_plantx.plant_path(r.plant_id)'
SourcedPartx.index_payment_request_path = "payment_requestx.payment_requests_path(:resource_id => r.id, :resource_string => params[:controller], :subaction => 'sourced_partx')"
SourcedPartx.payment_request_resource = 'payment_requestx/payment_requests'
