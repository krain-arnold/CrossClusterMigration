#
# This method takes the JSON objects set as state variables in GetResources, modifies them accordingly for a deployment in the second cluster, and saves the 
# modified objects as state variables with the naming convention "#{original_name}_modified"
#

def log(msg, level = :info)
  $evm.log(level, "#{msg}")
end

def remove_status(resource)
  resource["items"][0].delete("status")
  return resource
end
  
def modify_route(routes)
  remove_status(routes)
  routes["items"][0]["spec"].delete("host")

  temp_hash = {
    "kind"       => "Route",
    "apiVersion" => "v1"
    }

  routes_one = routes["items"][0]
  final_hash = temp_hash.merge(routes_one)
  final_hash["metadata"]["resourceVersion"] = " "
  return final_hash
end

def modify_deployment_config(deployment_config)
  remove_status(deployment_config)
  deployment_config["items"][0]["spec"]["template"]["spec"]["containers"][0]["image"] = " "

  temp_hash = {
    "kind"       => "DeploymentConfig",
    "apiVersion" => "v1"
    }

  deployment_config_one = deployment_config["items"][0]
  final_hash = temp_hash.merge(deployment_config_one)
  final_hash["metadata"]["resourceVersion"] = " "
  return final_hash
end

def modify_image_streams(image_streams)
  remove_status(image_streams)

  temp_hash = {
    "kind"       => "ImageStream",
    "apiVersion" => "v1"
    }

  image_streams_one = image_streams["items"][0]
  final_hash = temp_hash.merge(image_streams_one)
  final_hash["metadata"]["resourceVersion"] = " "
  return final_hash
end

def modify_services(services)
  remove_status(services)

  temp_hash = {
    "kind"       => "Service",
    "apiVersion" => "v1"
    }

  services_one = services["items"][0]
  final_hash = temp_hash.merge(services_one)
  final_hash["metadata"]["resourceVersion"] = " "
  return final_hash
end

begin
deployment_config = $evm.get_state_var("deployment_config")
services          = $evm.get_state_var("services")
image_streams     = $evm.get_state_var("image_streams")
routes            = $evm.get_state_var("routes")

$evm.set_state_var("image_streams_modified", modify_image_streams(image_streams))
$evm.set_state_var("deployment_config_modified", modify_deployment_config(deployment_config))
$evm.set_state_var("services_modified", modify_services(services))
$evm.set_state_var("routes_modified", modify_route(routes))
end
