# CEDAR Docker - Quick Install Guide

This guide describes the steps for installing CEDAR using Docker.
The guide makes the simplifying assumption that the domain name of the system will be ``metadatacenter.orgx``.
A later version of this guide will describe how an arbitrary domain name can be used and will describe how SSL certificates can be generated and used for such a deployment.

This guide assumes a Unix-based system.
The deployment described here was verified to work on OS X El Capitan (10.11.6) and CentOS 7,
though it should work equally well on any Unix system.
It has not been tested to work on Windows systems.

To install you will need root access and at least 8GB of memory to allocate to Docker and reasonable hard drive free space.

## Deployment Steps

### 1.Install Docker

Download and install Docker Community Edition from [here](https://www.docker.com/community-edition).
After lunching Docker select the ```Open Preferences->Advanced``` menu option and set the memory size
to at least 8 GB; if possible also assign more than one CPU. Then apply the changes and restart Docker.

On some systems you may need to install the ```docker-compose``` command line tool.

### 2. Set up CEDAR_HOME and CEDAR_DOCKER_SRC_HOME variables

The CEDAR_HOME variable specifices the base location for a local Docker deployment of CEDAR.

Currently, two repositories must be downloded to deploy CEDAR.
The download directory for these repos is specified using the CEDAR_DOCKER_SRC_HOME directory.

Open the deployment account ```~./bash_profile``` or ```~/.bashrc``` file (or equivalent) and add the following lines:

    export CEDAR_HOME=~/cedar-home # Example only - pick a desired location
    export CEDAR_DOCKER_SRC_HOME=~/cedar-docker-src # Example only - pick a desired location

Close the current shell and start a new one.

### 3. Download the CEDAR Docker repos from GitHub

Create deployment and source directories if needed and download the two CEDAR Docker repos to the source directory:

    mkdir -p ${CEDAR_HOME}  # Create the base CEDAR deployment directory
    mkdir -p ${CEDAR_DOCKER_SRC_HOME} # Create the source directory for CEDAR components
    git clone --branch master --single-branch https://github.com/metadatacenter/cedar-docker-build.git ${CEDAR_DOCKER_SRC_HOME}/cedar-docker-build
    git clone --branch master --single-branch https://github.com/metadatacenter/cedar-docker-deploy.git ${CEDAR_DOCKER_SRC_HOME}/cedar-docker-deploy

### 4. Establish core deployment environment variables

The CEDAR Docker deployment repo has two files containing environment variables that are used in a deployment.
These files are called ```set-env-internal.sh```, which contains internal deployment variables, and ```set-env-external.sh```,
which contains external variables.

First copy these two files from the source repo to the CEDAR deployment directory:

    cp ${CEDAR_DOCKER_SRC_HOME}/cedar-docker-deploy/bin/original/set-env-internal.sh ${CEDAR_HOME}
    cp ${CEDAR_DOCKER_SRC_HOME}/cedar-docker-deploy/bin/original/set-env-external.sh ${CEDAR_HOME}

You can customize the variables in both of these files as needed by the deployment.

For the moment, do not change the domain name (``metatadatacenter.orgx``) or the IP address variables in the internal file.
It is recommended that you change the default passwords and the CEDAR_ADMIN_USER_API_KEY and CEDAR_SALT_API_KEY variables.

You will need to set a BioPortal API key in the external file.
Please create a new BioPortal account for your installation's use by [registering for a separate BioPortal account](https://bioportal.bioontology.org/accounts/new). This will help us in diagnosing issues and managing access to the systems.
The relevant variable to set is called CEDAR_BIOPORTAL_API_KEY.

### 5. Incorporate environment variables and set useful CEDAR command aliases

We have also created a set of useful aliases for commands that execute and monitor CEDAR services.
These command aliases will be used in the remainder of this guide.
These aliases can be set by running the two scripts as follows:

    source ${CEDAR_DOCKER_SRC_HOME}/cedar-docker-deploy/bin/util/set-env-generic.sh
    source ${CEDAR_DOCKER_SRC_HOME}/cedar-docker-deploy/bin/util/set-docker-aliases.sh

The ensure these aliases are available in all shells, open the deployment account ```~./bash_profile``` or ```~/.bashrc``` file (or equivalent) and add the lines above.

The final set of CEDAR-related environment variable assignments should look as follows:

    export CEDAR_HOME=~/cedar-home # Example only - pick a desired location
    export CEDAR_DOCKER_SRC_HOME=~/cedar-docker-src # Example only - pick a desired location
    source ${CEDAR_HOME}/set-env-external.sh
    source ${CEDAR_HOME}/set-env-internal.sh
    source ${CEDAR_DOCKER_SRC_HOME}/cedar-docker-deploy/bin/util/set-env-generic.sh
    source ${CEDAR_DOCKER_SRC_HOME}/cedar-docker-deploy/bin/util/set-docker-aliases.sh
    
### 6. Create Docker network and volumes

Execute the following commands to create a Docker network and create Docker volumes.

    source ${CEDAR_DOCKER_SRC_HOME}/cedar-docker-deploy/bin/docker-create-network.sh
    source ${CEDAR_DOCKER_SRC_HOME}/cedar-docker-deploy/bin/docker-create-volumes.sh

The network will be used by all CEDAR services.
The volumes are used for persistent storage.

### 7. Copy SSL certificates and mark certification authority as trustable

The following command will copy pre-canned SSL certificates for the appropriate ``metadatacenter.orgx`` subdomains from the
source Docker repository to the deployment directory:

    source ${CEDAR_DOCKER_SRC_HOME}/cedar-docker-deploy/bin/docker-copy-certificates.sh

You will need to mark the certification authority certificate as trustable so that your browser will treat these pre-canned certificates as valid.

After the above copy, the certification authority certificate will be stored in the following file:

     ${CEDAR_DOCKER_SRC_HOME}/cedar-docker-deploy/cedar-assets/ca/ca-cedar.crt

The mechanism to mark this certification authority as trustable varies by operating system and browser. 

On OS X this certificate can be opened by double clicking on it in the Finder, which will open the Keychain Access application.
Locate the just-added certificate by searching for 'metadatacenter'.
You should see a certificiate for ```metadatacenter.orgx```.
Double click on it, which should open a detail panel for the certificate.
Go to the 'Trust' item and select 'Always Trust' for the 'When using this certificate' question.
Close the detail panel.
You should see the icon of the certificate having a white cross inside a blue circle.

### 8. Start the CEDAR services

The CEDAR components are divided into four main sets:
(1) infrastructure services, which include persistent storage services, such as MongoDB, Neo4j and the like,
(2) microservices, which represent core CEDAR services,
(3) the frontend, which contains all user-facing services, and
(4) monitoring services, which can be used to examine a running system.

For ease of monitoring, each set of services should be started in a new shell.

The CEDAR infrastructure services can be started using the following command:

    startinfrastructure

The microservices can be started as follows:

    startmicroservices

The frontend can be started using the following command:

    startfrontend

And, finally, the monitoring services can be started as follows:

    startmonitoring

You can examine the status of running components using the ``cedarss`` command.
It will list all CEDAR services and their status.

### 9. Log in to the CEDAR application

Check the application from a browser at the following URL [https://cedar.metadatacenter.orgx](https://cedar.metadatacenter.orgx).

Log in with one of these user/password combinations: ``cedar-admin``/``Password123``, ``test1@test.com``/``test1``, ``test2@test.com``/``test2``, ``my@user.com``/``my``

The Keycloak administration interface is located [here](https://auth.metadatacenter.orgx/auth/admin/).

You can log in to Keycloak with the following user/password combination: ``administrator``/``changeme``
