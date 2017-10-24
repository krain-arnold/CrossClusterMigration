#
# This method will create an OpenShift Project based on the value of dialog_project_name.
#
require 'rest-client'

def log(msg, level = :info)
  $evm.log(level, "#{msg}")
end

def call_openshift(action, headers, token, ocp_url, payload=nil)
query = ":8443/oapi/v1/projectrequests"
url   = "#{ocp_url}#{query}"
  
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
action         = :post
ocp_url_2      = $evm.object['OcpUrl2']
ocp_token_2    = $evm.object.decrypt('OcpToken2')
project        = $evm.root['dialog_project_name'].downcase

headers = {
  :accept        => 'application/json',
  :content_type  => 'application/json',
  :authorization => "Bearer #{ocp_token_2}"
}  

payload = {:kind=>"ProjectRequest",
   :apiVersion=>"v1",
   :metadata=>{:name=>project, :creationTimestamp=>nil}}.to_json

response = call_openshift(action, headers, ocp_token_2, ocp_url_2, payload)
log("The Project #{project} has been created on the target OCP Cluster. Response follows: #{response}")
end
