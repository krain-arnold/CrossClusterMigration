#
# This method will populate the project that was created in CreateProject with the appropriate Image Streams, Deployment Configs,
# Services, and Routes using the modified JSON objects created in ModifyJson
#
require 'rest-client'

def log(msg, level = :info)
  $evm.log(level, "#{msg}")
end

def call_openshift(action, headers, token, ocp_url, resource, project, payload=nil)
query = resource=="services" ? ":8443/api/v1/namespaces/" : ":8443/oapi/v1/namespaces/" #A ternary expression to control for inconsistencies in the OCP API
url   = "#{ocp_url}#{query}#{project}/#{resource}"

params = {
  :method     => action,
  :url        => url,
  :headers    => headers,
  :verify_ssl => false
  }

params[:payload] = payload if payload
response = RestClient::Request.new(params).execute
return JSON.parse(response)
end

begin
routes_modified            = $evm.get_state_var("routes_modified").to_json
services_modified          = $evm.get_state_var("services_modified").to_json
deployment_config_modified = $evm.get_state_var("deployment_config_modified").to_json
image_streams_modified     = $evm.get_state_var("image_streams_modified").to_json
resource_dc                = "deploymentconfigs"
resource_svc               = "services" #uses api instead of oapi
resource_rt                = "routes"
resource_is                = "imagestreams"
action                     = :post
ocp_url_2                  = $evm.object['OcpUrl2']
ocp_token_2                = $evm.object.decrypt('OcpToken2')
project                    = $evm.root['dialog_project_name'].downcase

headers = {
  :accept        => 'application/json',
  :content_type  => 'application/json',
  :authorization => "Bearer #{ocp_token_2}"
}

call_openshift(action, headers, ocp_token_2, ocp_url_2, resource_is, project, image_streams_modified)
call_openshift(action, headers, ocp_token_2, ocp_url_2, resource_dc, project, deployment_config_modified)
call_openshift(action, headers, ocp_token_2, ocp_url_2, resource_svc, project, services_modified)
call_openshift(action, headers, ocp_token_2, ocp_url_2, resource_rt, project, routes_modified)
end
