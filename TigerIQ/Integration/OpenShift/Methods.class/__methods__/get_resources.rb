#
# This method retrieves the Image Stream, Service, Deployment Config, and Route information for the specified OpenShift Application
#
require 'rest-client'

def log(msg, level = :info)
  $evm.log(level, "#{msg}")
end

def error(msg)
  $evm.log(:error, msg)
  $evm.root['ae_result'] = 'error'
  $evm.root['ae_reason'] = msg.to_s
  exit MIQ_OK
end

def call_openshift(action, headers, token, ocp_url, resource, project, payload=nil)
query = resource=="services" ? ":8443/api/v1/namespaces/" : ":8443/oapi/v1/namespaces/" #ternary expression to control for the inconsistent OCP API
url   = "#{ocp_url}#{query}#{project}/#{resource}"
  
params = {
  :method     => action,
  :url        => url,
  :headers    => headers,
  :verify_ssl => false
  }
params[:payload] = payload if payload
response = RestClient::Request.new(params).execute
log(response)
return JSON.parse(response)
end

begin
project        = $evm.root['dialog_project_name']
action         = :get
ocp_url_1      = $evm.object['OcpUrl1']
ocp_token_1    = $evm.object.decrypt('OcpToken1')
resource_dc    = "deploymentconfigs"
resource_svc   = "services" #uses api instead of oapi
resource_rt    = "routes"
resource_is    = "imagestreams"

headers = {
  :accept        => 'application/json',
  :content_type  => 'application/json',
  :authorization => "Bearer #{ocp_token_1}"
}

$evm.set_state_var("image_streams", call_openshift(action, headers, ocp_token_1, ocp_url_1, resource_is, project))
$evm.set_state_var("deployment_config", call_openshift(action, headers, ocp_token_1, ocp_url_1, resource_dc, project))
$evm.set_state_var("services", call_openshift(action, headers, ocp_token_1, ocp_url_1, resource_svc, project))
$evm.set_state_var("routes", call_openshift(action, headers, ocp_token_1, ocp_url_1, resource_rt, project))
end
