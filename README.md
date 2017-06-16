# CEDAR Docker version - Quick Install Guide
## Disclaimer

The below guide present an easy path to install CEDAR in a quick way.

In order to achieve this, it makes several assumptions:
* The domain name of the system will be ``metadatacenter.orgx``
* The related files will be stored in a directory named ``cedar-docker-home`` in the user's home folder
* The user does not want to change the default passwords
    
If these assumptions are not acceptable, one should refer to the full version of this install guide.

## Prerequisites
This guide was prepared and tested on macOS Sierra (v 10.12.5).

To our best knowledge it will work without changes on Unix systems.

It will not work on Windows systems (mainly because of the *.sh files) 

In order to proceed, you will need the following
* Root access - used only in one of the steps
* At least 8GB memory (CEDAR will require 6GB)
* Reasonable free space on your hard drive (in the user's home folder)

## IMPORTANT - Updating environment variables - PLEASE READ
During this install process, you will need to set or update several environment variables, several times.

Some of the environment variables will be added to your ``~/.bash_profile`` or ``~/.bashrc`` file.

Other environment variables will come from scripts included in one of the above files.
 
After making changes to the environment variables by changing a value, or including a file into your profile, **it is crucial** that these changes take effect.

There are at least two ways to achieve this:
1. Close the current shell, and open a new one. This way it is guarranteed that the new shell has all the changes.
1. You can source the ``~/.bash_profile`` or ``~/.bashrc`` file. By doing this, the additions and changes will take effect, but the possibly removed variables will still be set.

We would suggest to use the first approach!

**During this guide we will warn you several times to make sure your environment variable changes are taken into account. Please close the current shell and open a new one in these cases!**
 
## Steps
### 1.Install Docker
Download and install Docker Community Edition from https://www.docker.com/community-edition

### 2. Fine-tune Docker 
After launching Docker:
* Open Preferences -> Advanced
* Set the Memory to 6 GB.
* If possible, also assign more than one CPU's.

Apply and Restart

### 3. Set up CEDAR_HOME and CEDAR_DOCKER_HOME variables

Edit your ```~./bash_profile``` or ```~/.bashrc``` file with your editor of choice, and add the below lines:

````
export CEDAR_HOME=~/cedar-home
export CEDAR_DOCKER_HOME=~/cedar-docker-home
````

**Make sure the above environment variable changes are taken into account. Follow the step at the beginning of this guide!**

### 4. Get the Docker image sources and compose files
Execute the below lines:

````
mkdir -p ${CEDAR_HOME}
git clone https://github.com/metadatacenter/cedar-docker-build.git ${CEDAR_HOME}/cedar-docker-build
git clone https://github.com/metadatacenter/cedar-docker-deploy.git ${CEDAR_HOME}/cedar-docker-deploy
cp ${CEDAR_HOME}/cedar-docker-deploy/cedar-assets/bin/set-env-base.sh ${CEDAR_HOME}/
````

### 5. Set base data for the installation
Edit the following file with your editor of choice:  

    ${CEDAR_HOME}/set-env-base.sh

If you have it, add the value for the below variable:
* ``CEDAR_BIOPORTAL_API_KEY``

**This guide will not describe the way you can get this value.**


### 6. Include environment variable setting scripts into your profile
Edit your ``~./bash_profile`` or ``~/.bashrc`` file with your editor of choice, and add the below lines:

````
source ${CEDAR_HOME}/set-env-base.sh
source ${CEDAR_HOME}/cedar-docker-deploy/bin/set-env-passwords.sh
source ${CEDAR_HOME}/cedar-docker-deploy/bin/set-env-common.sh
````

**Make sure the above environment variable changes are taken into account. Follow the step at the beginning of this guide!**

### 7. Create Docker subnet, create directories, copy certificates
Execute the below lines:

````
bash ${CEDAR_HOME}/cedar-docker-deploy/bin/create-network.sh
bash ${CEDAR_HOME}/cedar-docker-deploy/bin/create-directories.sh
bash ${CEDAR_HOME}/cedar-docker-deploy/bin/copy-certificates.sh
````

### 8. Add domains to /etc/hosts
**You will need to have sudo privileges for this step!**

Execute the below line:
 
    sudo bash -c "cat ${CEDAR_HOME}/cedar-docker-deploy/cedar-assets/etc/hosts >> /etc/hosts"

### 9. Initialize MySQL
**This step is needed only once for a new installation!**

Execute the below lines:

````
goinfrastructure
docker-compose up mysql
````

You will see the following output:

````
mysql               | CEDAR: exporting variables ...
mysql               | CEDAR: executing original entrypoint: mysqld
mysql               | Initializing database

...

mysql               | /entrypoint.sh: ignoring /docker-entrypoint-initdb.d/*
mysql               |
mysql               |
mysql               | MySQL init process done. Ready for start up.
````
After the last line was shown, stop this container with ``Ctrl + C`` 

### 10. Start the infrastructure services
Execute the below lines:

````
goinfrastructure
docker-compose up
````

### 11. Start the frontend
In a new shell execute the below lines:

````
gofrontend
docker-compose up
````

### 12. Start the monitoring tools
**This step will be optional later, but for now, at the first run, you will need to perform this initialization step!**

In a new shell execute the below lines:

````
gomonitoring
docker-compose up
```` 

After you see the below line (or the console stops to output new lines):

````
admin-tool         | Waiting for users
````

In a new shell execute the below line:

    docker exec -it admin-tool bash

You will be logged into a Linux shell. Execute the following command:

    cedarat folderServer-createGlobalObjects
 
Exit this shell with ``exit`` or ``Ctrl + C``

### 13. Start the microservices
In a new shell execute the below lines:

````
gomicroservices
docker-compose up
```` 

### 14. Import CA certificate
Open the following file in Finder: ``${CEDAR_DOCKER_HOME}/ca/ca-cedar.crt`` by double-clicking it.
 
* The ``Keychain Access`` application  will be launched.
* A dialog will pop up, prompting for a location for the certificate. The ``login`` will be preselected. Click the ``Add`` button.
* Locate the certificate you just added, by searching for ``metadatacenter`` in to top right corner.
* The certificate will have a white cross in a red circle, meaning it is not trusted.
* Open it by double-clicking it.
* Expand the ``Trust`` branch on the top.
* Change the dropdown labeled ``When using this certificate``: to ``Always Trust``
* Close the popup.
* You will be prompted for your password.
* You should see the icon of the certificate having a white cross inside a blue circle.
* Close the ``Keychain Access``

### 15. Log in to the application
Check the application from a browser:

https://cedar.metadatacenter.orgx

Log in with these users:
* cedar-admin / Password123
* test1@test.com / test1
* test2@test.com / test2
* my@user.com / my

The Keycloak (user admin UI) is located at

https://auth.metadatacenter.orgx/auth/admin/

Log in with:
* administrator / changeme
