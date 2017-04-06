# Marine Planner Core

### This is the top level project for Marine Planner Projects

### ~Development Installation

##### Bootstrap from scratch:
* Clone marineplanner-core onto your local system
* Copy scripts/configure_project.sh.template to scripts/configure_project.sh
* make configure_project.sh executable
* run your new configure_project script (may need to open in vim and enter :set fileformat=unix)
* `vagrant up`
* wait 30 minutes (or more if you don't have the base box or have a slow connection)

###### MAC
If you have [Vagrant](https://www.vagrantup.com/downloads.html) installed on Mac:
```bash
git clone https://github.com/Ecotrust/marineplanner-core.git
cd marineplanner-core/scripts
cp configure_project.sh.template.mac configure_project.sh
chmod +x configure_project.sh
./configure_project.sh
vagrant up
```

###### Linux
If you have [Vagrant](https://www.vagrantup.com/downloads.html) installed on Linux:
```bash
git clone https://github.com/Ecotrust/marineplanner-core.git
cd marineplanner-core/scripts
cp configure_project.sh.template configure_project.sh
chmod +x configure_project.sh
./configure_project.sh
vagrant up
```

###### Run test server
```bash
vagrant ssh
cd /usr/local/apps/marineplanner-core/
source env/bin/activate
cd marineplanner
python manage.py runserver 0.0.0.0:8000
```
Then go [here](http://localhost:8111/visualize)


##### Creating a new app from scratch:
* Create a new repository in GitHub (or other)
* Clone marineplanner-core onto your local system
* Clone your new repository into the apps folder
* ... (some work left to do here)
* Create your new app in the marineplanner-core project:
* `python manage.py startapp appname`
* Move your app into your repository folder
* Make app installable
* Copy scripts/configure_project.sh.template to scripts/configure_project.sh
  * Set your explicit project folder if you want one ($CORE/apps/$APP_NAME/marineplanner_files/)
  * Uncomment the modules you want included
    * `cd scripts/`
    * `./configure_project.sh projname` where 'projname' is the name of your project repository
* make configure_project.sh executable
* run your new configure_project script (may need to open in vim and enter :set fileformat=unix)
* `vagrant up`
* wait while vagrant builds a new VM and provisions it

=== Old Notes (under construction)===


9. You probably want to create a superuser once you're in your VM, so that you have access to both the Django and Wagtail backend

##### Using Vagrant
* Access your VM by running `vagrant ssh`. This will automatically log you into your virtual machine with your virtual environment activated at the project root level.

* **Shortcuts**
  * To use `/manage.py` with normal django administrative tasks , use the keyword `dj`

      ```
      dj makemigrations
      dj migrate
      dj createsuperuser
      dj dumpdata
      etc.
      ```

  * Typing `djrun` will run your dev server - remember to add your sample data first (see #5):


*  **NOTE:** The provisioning script is designed for a fresh install and will completely wipe the database and any associated content - IF you decide to shutdown your VM! Outside of halting your vagrant machine, running `vagrant up` or `vagrant provision` will cause the provisioning script to re-run. Adding the flag `--no-provision` to `vagrant up` will ignore the script.

#### **** OPTIONAL ***
If you decide to use pgAdmin3 for database management rather than using the command line, you'll need to allow/enable access to your virtual machine.
*  Enter into `postgres.conf` and change `listen_addresses`:
  ```
  sudo nano /etc/postgresql/9.3/main/postgresql.conf
  listen_addresses = '*'
  ```

* Enter into `pg_hba.conf` and add the `host` line:
  ```
   sudo nano /etc/postgresql/9.3/main/pg_hba.conf
   host    all    all    10.0.0.0/16     md5
  ```

* Restart postgresql
  ```
  sudo /etc/init.d/postgresql restart
  ```

* Within pgAdmin3, modify your settings:
     *  **Name:** marineplanner
     *  **Host:** localhost
     *  **Port:** 65432
     *  **Username:** vagrant


### ~Code Deployment
Since this project is modularized, changes to a submodule only requires server updates to that specific submodule - rather than the entire code base.

1.  SSH into the server
2.  Activate your virtual env - `source ~/env/marineplanner-core/bin/activate`
3.  Navigate to the submodule that you're updating
    *  Submodules are located at `cd /home/[username]/env/marineplanner-core/src/[THE-NAME-OF-YOUR-SUBMODULE]`
4.  Once you're at that path - `git fetch && git reset -q --hard origin/master`
    *  `origin/master` pertains to the main master branch - you can change that to whatever your branch you'd like
5.  Navigate to `cd ~/webapps/marineplanner/[project module]`
6.  Run `python manage.py collectstatic` to collect all the neccessary static (js/css) files
    * you can use the -i flag to ignore utfgrids in the rare chance that those files seems to be "collecting"
    * `python manage.py collectstatic -i utfgrid`
7.  Run `python manage.py compress` to compress
8.  Restart the server - `~/webapps/marineplanner/apache2/bin/restart`

### ~Adding a new module to the apps directory and deployment
Adding a new module to Marine Planner requires a few additional steps for both local/development setup and deployment.

**Local/Development setup**:  

1. create directory within `marineplanner-core/apps`
    * Use `git clone` for exisiting module or create a new direcotry and use `git init` to set up your new repository.
        * If this is a new git repository create a new remote origin repo within the [Ecotrust](https://github.com/Ecotrust) orgainization. *Next steps assume your new module is ready to use.*
2. open `marineplanner-core/requirements.txt` and add the newly created git remote repository (*e.g.* `-e git+https://github.com/Ecotrust/your_new_repo.git@master#egg=an_alias`). *the `@master#egg=` assigns an alias (simple name) for your module*
3. open `marineplanner-core/[project]/[module]/settings.py` and add your new module's alias as an `INSTALLED_APPS`. (*e.g.*, `INSTALLED_APPS = [ 'an_alias']`)
4. run `vagrant provision`


**Deployment**:  

1. ssh into the server (sandbox or production)
2. activate your virtual env - `source ~/env/marineplanner-core/bin/activate`
3. navigate to the submodule directory `cd /home/[username]/env/marineplanner-core/src/`
4. `git clone` your new module repository
5. navigate to the marineplanner-core repo `cd ~/code/marineplanner-core/master/`
6. run `git fetch && git reset -q --hard origin/master`
7. open the `requirements.txt` file and copy the line you added for your repo (*e.g.*, `-e git+https://github.com/Ecotrust/new_repo.git@master#egg=an_alias`)
8. enter `pip install` and paste (*e.g.*,`pip install -e git+https://github.com/Ecotrust/new_repo.git@master#egg=an_alias` ) and run
9. navigate to `cd ~/webapps/marineplanner-core/[project]`
10. run `python manage.py collectstatic -i utfgrid`
11. run `python manage.py compress`
12. restart the server - `~/webapps/marineplanner-core/apache2/bin/restart`  
