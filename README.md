# CrossClusterMigration
An example of a CFME workflow that pushes OCP Projects across Clusters

# Contents
* [Features](#features)
* [Installation](#installation)
* [Dependencies](#dependencies)


# Features
The code in this repository will collect all the resource information from a specified Project in OpenShift
and deploy an identical Project in another Cluster. It provides an option to delete the original Project
after the migration is complete. This is intended as a framework for similar automation workflows. The 
OpenShift Project that was used in this example is available [here](https://github.com/tahonen/tigerinapod).



# Installation
1. Automation -> Automate -> Import/Export
2. Import Datastore via git (Git role must be enabled on the appliance)
3. Git URL: 'https://github.com/krain-arnold/CrossClusterMigration.git'
4. Submit
5. Select Branc/Tag to syncronize with
6. Submit

# Dependencies
The automation should be triggered by a Service Catalog Item with a dialog that contains the following variables:
* dialog_project_name: This is the name of the project to be migrated
* delete_original: If this is set to "true" the original Project will be deleted upon completion of the migration

