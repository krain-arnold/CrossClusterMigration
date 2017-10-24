#
# This Method will delete the Project from the original OpenShift Cluster if that option was selected during ordering.
#
require 'rest-client'

def log(msg, level = :info)
  $evm.log(level, "#{msg}")
end

def delete_openshift_project(action, headers, token, ocp_url, project, payload=nil)
query = ":8443/oapi/v1/projects/"
url   = "#{ocp_url}#{query}#{project}"

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
action          = :delete
ocp_url_1       = $evm.object['OcpUrl1']
ocp_token_1     = $evm.object.decrypt('OcpToken1')
delete_original = $evm.root['dialog_delete_original_project']
project         = $evm.root['dialog_project_name'].downcase

headers = {
  :accept        => 'application/json',
  :content_type  => 'application/json',
  :authorization => "Bearer #{ocp_token_1}"
}

if delete_original == 'true'
  response = delete_openshift_project(action, headers, ocp_token_1, ocp_url_1, project)
  log("The original Project has been marked for deletion. API Response follows: #{response}")
else
  log("The original Project has not been marked for deletion. The Migration is complete.")
end
end
