# CEDAR Docker - Quick Install Guide

This guide describes the steps for installing CEDAR using Docker.
The guide makes the simplifying assumption that the domain name of the system will be ``metadatacenter.orgx``.
A later version of this guide will describe how an arbitrary domain name can be used and will describe how SSL certificates can be generated and used for such a deployment.

This guide assumes a Unix-based system.
The deployment described here was verified to work on on OS X El Capitan (10.11.6) and CentOS 7,
though it should work equally well on any Unix system.
It has not been tested to work on Windows systems.

To install you will need root access at least 8GB of memory (CEDAR will require 6GB) and reasonable free space on your hard drive.

The latests versions of ```Docker``` and the ```docker-compose``` command should be first installed.

## Steps
### 1.Install Docker

Download and install Docker Community Edition from [here](https://www.docker.com/community-edition).
After lunching Docker select the ```Open Preferences->Advanced``` menu option and set the memory size
to at least 6 GB; if possible also assign more than one CPU. Then apply the changes and restart Docker.

### 2. Set up CEDAR_HOME and CEDAR_DOCKER_SRC_HOME variables

The CEDAR_HOME variable specifices the base location for a local Docker deployment of CEDAR.
This directory will contain persistent state and other deployment information.

Currently, two repositories must be downloded to initially deploy CEDAR.
The download directory for this repos is specified using the CEDAR_DOCKER_SRC_HOME directory.

Open your ```~./bash_profile``` or ```~/.bashrc``` file and add the following lines:

    export CEDAR_HOME=~/cedar-home # Example only - pick a suitable location
    export CEDAR_DOCKER_SRC_HOME=~/cedar-docker-src # Example only - pick a suitable locaton

Close the current shell and start a new one.

### 3. Download the CEDAR Docker repos from Nexus

Create deployment and source directories if needed and download the two CEDAR Docker repos to the source directory:

    mkdir -p ${CEDAR_HOME}  # Create the base CEDAR deployment directory
    mkdir -p ${CEDAR_DOCKER_SRC_HOME} # Create the source directory for CEDAR components
    git clone --branch master --single-branch https://github.com/metadatacenter/cedar-docker-build.git ${CEDAR_DOCKER_SRC_HOME}/cedar-docker-build
    git clone --branch master --single-branch https://github.com/metadatacenter/cedar-docker-deploy.git ${CEDAR_DOCKER_SRC_HOME}/cedar-docker-deploy

### 4. Include environment variable setting scripts into your profile

The CEDAR deployment repo has two sets of files containing environment variables that are used in a deployment.
These files are called ```set-env-internal.sh```, which contains internal deployment, and ```set-env-external.sh```,
which contains external variables.

First copy these example files to your deployment repo:

   cp ${CEDAR_DOCKER_SRC_HOME}/cedar-docker-deploy/bin/original/set-env-internal.sh ${CEDAR_HOME}
   cp ${CEDAR_DOCKER_SRC_HOME}/cedar-docker-deploy/bin/original/set-env-external.sh ${CEDAR_HOME}

You can customized the variables in both of these files as needed by your deployment.

For the moment, do not change the domain name (``metatadatcenter.orgx``) or the IP address variables in the internal file.
It is recommended that you change the default passwords and the CEDAR_ADMIN_USER_API_KEY and CEDAR_SALT_API_KEY variables.

You will need to set a BioPortal API key in the external file.
If you do not already have a BioPortal API key, you can created one by [registering for a BioPortal account](https://bioportal.bioontology.org/accounts/new).
The relvant variable to set is called ``CEDAR_BIOPORTAL_API_KEY`.

### 5. Create Docker Network and Volumes and Copy Default SSL Certificates

Execute the following commands to create a Docker network, create Docker volumes, and

    godeploy

    ./bin/docker-create-network.sh
    ./bin/docker-create-volumes.sh
    ./bin/docker-copy-certificates.sh

### 6. Start the CEDAR Services

The CEDAR components are divided into four main sets: (1) infrastructure services, which include persistent storage services, such as MongoDB, Neo4j and the like, (2) microservices, which represent core CEDAR services, (3) the frontend, which contains all user-facing services, and (4) monitoring services, which can be used to examine a running system.

For ease of monitoring, each set of services should be started in a new shell.

The CEDAR infrastructure services can be started using the following command:

    startinfrastructure

The microservices can be started as follows:

    startmicroservices

The frontend can be started using the folloing command:

    startfrontend

And, finally, the monitoring services can be started as follows:

   startmonitoring

You can examine the status of running components using the ```cedarss`` command.
 It will list all CEDAR services and their status.

### 7. Log in to the CEDAR Application

Check the application from a browser at the following URL [https://cedar.metadatacenter.orgx](https://cedar.metadatacenter.orgx).

Log in with these user/password combinations: cedar-admin/Password123, test1@test.com/test1, test2@test.com/test2, my@user.com/my

The Keycloak administration interface is located [here](https://auth.metadatacenter.orgx/auth/admin/).

You can log in to Keycloak with the following user/password combination: administrator/changeme

## IMPORTANT - Updating environment variables - PLEASE READ
During this install process, you will need to set or update several environment variables, several times.
Some of the environment variables will be added to your ``~/.bash_profile`` or ``~/.bashrc`` file.
Other environment variables will come from scripts included in one of the above files.
After making changes to the environment variables by changing a value, or including a file into your profile, **it is crucial** that these changes take effect.

There are at least two ways to achieve this:
1. Close the current shell, and open a new one. This way it is guarranteed that the new shell has all the changes.
1. You can source the ``~/.bash_profile`` or ``~/.bashrc`` file. By doing this, the additions and changes will take effect, but the possibly removed variables will still be set.

We would suggest to use the first approach!
