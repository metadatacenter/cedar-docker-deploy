# CEDAR Docker - Quick Install Guide

This guide describes the steps for installing CEDAR using Docker. The guide makes several simplifying assumptions: 
(1) The domain name of the system will be ``metadatacenter.orgx``;
(2) The related files will be stored in a directory named ``cedar-docker-home`` in the user's home folder;
and (3) The user does not want to change the default passwords. 
If these assumptions are not acceptable, one should refer to the full version of this install guide.

This guide was prepared and tested on macOS Sierra (v10.12.5).
To our best knowledge it will work without changes on Unix systems.
It has not been tested to work on Windows systems.
To install you will need root access at least 8GB of memory (CEDAR will require 6GB) and reasonable free space on your hard drive.

## Steps
### 1.Install Docker

Download and install Docker Community Edition from [here](https://www.docker.com/community-edition).
After lunching Docker select the ```Open Preferences->Advanced``` menu option and set the memory size
to at least 6 GB; if possible also assign more than one CPU. Then apply and restart Docker.

### 2. Set up CEDAR_HOME and CEDAR_DOCKER_HOME variables

Open your ```~./bash_profile``` or ```~/.bashrc``` file and add the following lines:

    export CEDAR_HOME=~/cedar-home
    export CEDAR_DOCKER_HOME=~/cedar-docker-home

Close the current shell and start a new one.

### 3. Get the CEDAR Docker repos

Execute the following lines:

    mkdir -p ${CEDAR_HOME}
    git clone https://github.com/metadatacenter/cedar-docker-build.git ${CEDAR_HOME}/cedar-docker-build
    git clone https://github.com/metadatacenter/cedar-docker-deploy.git ${CEDAR_HOME}/cedar-docker-deploy
    cp ${CEDAR_HOME}/cedar-docker-deploy/cedar-assets/bin/set-env-base.sh ${CEDAR_HOME}/


### 4. Include environment variable setting scripts into your profile

Edit your ``~./bash_profile`` or ``~/.bashrc`` file with your editor of choice, and add the following lines:

    source ${CEDAR_HOME}/set-env-base.sh
    source ${CEDAR_HOME}/cedar-docker-deploy/bin/set-env-passwords.sh
    source ${CEDAR_HOME}/cedar-docker-deploy/bin/set-env-common.sh
    source ${CEDAR_HOME}/cedar-docker-deploy/bin/aliases.sh

Close the current shell and start a new one.

### 5. Create Docker subnet, create directories, copy certificates
Execute the following commands:

    bash ${CEDAR_HOME}/cedar-docker-deploy/bin/create-network.sh
    bash ${CEDAR_HOME}/cedar-docker-deploy/bin/create-directories.sh
    bash ${CEDAR_HOME}/cedar-docker-deploy/bin/copy-certificates.sh

### 6. Add redirect for ```metadatacenter.orgx``` to ```/etc/hosts```

Execute the following command:
 
    sudo bash -c "cat ${CEDAR_HOME}/cedar-docker-deploy/cedar-assets/etc/hosts >> /etc/hosts"

### 7. Set the BioPortal API key for the installation

Edit the file ```${CEDAR_HOME}/set-env-base.sh``` and add your BioPortal API key as the value of the ``CEDAR_BIOPORTAL_API_KEY`` variable.
If you do not already have a BioPortal API key, you can created one by [registering for a BioPortal account](https://bioportal.bioontology.org/accounts/new).

### 8. Initialize MySQL

**This step is temporary and will not be needed shortly.**

Execute the following commands:

    goinfrastructure
    docker-compose up mysql

After the console stops outputting new lines, open a new shell window, and execute the following commands:

    goinfrastructure
    docker-compose down

### 9. Start the infrastructure services

Execute the following commands:

    goinfrastructure
    docker-compose up

### 10. Start the frontend

In a new shell execute the following commands:

    gofrontend
    docker-compose up

### 11. Start the Monitoring Tools

In a new shell execute the following commands:

    gomonitoring
    docker-compose up

### 12. Initialize Neo4J

**This step is temporary and will not be needed shortly.**

After the console stops outputting new lines execute the following command in a new shell:

    docker exec -it admin-tool bash

You will be logged into a Linux shell. Execute the following command:

    cedarat workspaceServer-createGlobalObjects
 
Exit this shell by typing ``exit``.

### 13. Start the Microservices

In a new shell execute the following commands:

    gomicroservices
    docker-compose up

### 13. Import CA Certificate

Open the following file in Finder: ``${CEDAR_DOCKER_HOME}/ca/ca-cedar.crt`` by double-clicking it.
The ``Keychain Access`` application  will be launched. A dialog will pop up, prompting for a location for the certificate.
The ``login`` will be preselected. Click the ``Add`` button.
Locate the certificate you just added, by searching for ``metadatacenter`` in to top right corner.
The certificate will have a white cross in a red circle, meaning it is not trusted.
Open it by double-clicking it.
Expand the ``Trust`` branch on the top.
Change the dropdown labeled ``When using this certificate``: to ``Always Trust``
Close the popup.
You will be prompted for your password.
You should see the icon of the certificate having a white cross inside a blue circle.
Close the ``Keychain Access`` application.

### 14. Log in to the CEDAR Application

Check the application from a browser at the following URL [https://cedar.metadatacenter.orgx](https://cedar.metadatacenter.orgx).

Log in with these users:
* cedar-admin / Password123
* test1@test.com / test1
* test2@test.com / test2
* my@user.com / my

The Keycloak administration interface is located [here](https://auth.metadatacenter.orgx/auth/admin/){:target="_blank"}.

Log in with:
* administrator / changeme

## IMPORTANT - Updating environment variables - PLEASE READ
During this install process, you will need to set or update several environment variables, several times.
Some of the environment variables will be added to your ``~/.bash_profile`` or ``~/.bashrc`` file.
Other environment variables will come from scripts included in one of the above files.
After making changes to the environment variables by changing a value, or including a file into your profile, **it is crucial** that these changes take effect.

There are at least two ways to achieve this:
1. Close the current shell, and open a new one. This way it is guarranteed that the new shell has all the changes.
1. You can source the ``~/.bash_profile`` or ``~/.bashrc`` file. By doing this, the additions and changes will take effect, but the possibly removed variables will still be set.

We would suggest to use the first approach!
