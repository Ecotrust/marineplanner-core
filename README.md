# MARCO Portal Redesign

### This is the top level project for the Mid-Atlantic Ocean Data Portal

### ~Development Installation

##### Initial Setup using Vagrant:
The following is the **_recommended_** folder structure for the **entire** MARCO project and the customized provisioning script is inherently dependent on it. Altering the folder and naming structure will require modifications to the provisioning script, so please be aware! The provisioning script is designed to be a **one-step** install after initial setup.

```
  -- marco-portal2
    -- apps (all remaining repositories within MidAtlanticPortal)
      -- mardona-analysistools
      -- madrona-features
      -- etc.
```


1.  To quickly clone all the repositiories from [MidAtlanticPortal](https://github.com/MidAtlanticPortal), run one of the following curl commands with Ruby/Perl. In doing so, this will clone all of the respositories at the same level and will require you to move all the non `marco-portal2` repositories to a subfolder - called `apps` as diagrammed above
    * RUBY:
    ```
    curl -s https://api.github.com/orgs/MidAtlanticPortal/repos?per_page=200 | ruby -rubygems -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["clone_url"]} ]}'
    ```
    * PERL:
    ```
    curl -s https://api.github.com/orgs/MidAtlanticPortal/repos\?per_page\=200 | perl -ne 'print "$1\n" if (/"clone_url": "([^"]+)/)' | xargs -n 1 git clone
    ```

2.  Once your folder structure is set up, create a `config.ini` file by making a copy of the `config.ini.template` located at `marco-portal2/marco` and modify the following
      * **MEDIA_ROOT:** /home/vagrant/marco_portal2/media
      * **STATIC_ROOT:** /home/vagrant/marco_portal2/static

3. Create a `/static/` directory at the root level and move the `/bower_components/` directory (also found at the root level) within it

4. Create a `/media/` directory at the root level and retrieve the live server's media folder via ssh/sftp located at `/webapps/marco_portal_media/` and add it to the `/media/` path. Refer to your team's technical documentation for server login (username and password) credentials
    * Of note - you may want to exclude the `data_manager` folder within the media directory - unless you're interested in several GBs of utfgrid layers.

5. Retrieve the data & content fixture from `/fixtures/dev_fixture.json` via ssh/sftp and place it at the root level of `marco-portal2`

6. Download and install [vagrant](https://www.vagrantup.com/downloads.html) and [virtual box](https://www.virtualbox.org/wiki/Downloads) (if you haven't already done so already)

7. At the root of `marco-portal2`, run `vagrant up` and let it install ALL of dependencies MARCO relies upon

8. At this point, you should be completely setup!

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
     *  **Name:** marco_portal
     *  **Host:** localhost
     *  **Port:** 65432
     *  **Username:** vagrant


### ~Code Deployment
Since this project is modularized, changes to a submodule only requires server updates to that specific submodule - rather than the entire code base.

1.  SSH into the server
2.  Activate your virtual env - `source ~/env/marco_portal2/bin/activate`
3.  Navigate to the submodule that you're updating
    *  Submodules are located at `cd /home/midatlantic/env/marco_portal2/src/[THE-NAME-OF-YOUR-SUBMODULE]`
4.  Once you're at that path - `git fetch && git reset -q --hard origin/master` 
    *  `origin/master` pertains to the main master branch - you can change that to whatever your branch you'd like
    *  Of note, the master *marco-portal2* branch runs as `origin/prototype`
5.  Navigate to `cd ~/webapps/marco_portal/marco`
6.  Run `python manage.py collectstatic` to collect all the neccessary static (js/css) files 
    * you can use the -i flag to ignore utfgrids in the rare chance that those files seems to be "collecting" 
    * `python manage.py collectstatic -i utfgrid`
7.  Run `python manage.py compress` to compress
8.  Restart the server - `~/webapps/marco_portal/apache2/bin/restart`

### ~Adding a new module to the apps directory and deployment
Adding a new module to marco requires a few additional steps for both local/development setup and deployment.

**Local/Development setup**:  

1. create directory within `marco-portal2/apps`
    * Use `git clone` for exisiting module or create a new direcotry and use `git init` to set up your new repository.
        * If this is a new git repository create a new remote origin repo within the [MidAtlanticPortal](https://github.com/MidAtlanticPortal) orgainization. *Next steps assume your new module is ready to use.*
2. open `marco-portal2/requirements.txt` and add the newly created git remote repository (*e.g.* `-e git+https://github.com/MidAtlanticPortal/your_new_repo.git@master#egg=an_alias`). *the `@master#egg=` assigns an alias (simple name) for your module*
3. open `marco-portal2/marco/marco/settings.py` and add your new module's alias as an `INSTALLED_APPS`. (*e.g.*, `INSTALLED_APPS = [ 'an_alias']`)
4. run `vagrant provision`


**Deployment**:  

1. ssh into the server (sandbox or production)
2. activate your virtual env - `source ~/env/marco_portal2/bin/activate`
3. navigate to the submodule directory `cd /home/midatlantic/env/marco_portal2/src/`
4. `git clone` your new module repository
5. navigate to the marco-portal repo `cd ~/code/marco_portal2/prototype/`
6. run `git fetch && git reset -q --hard origin/prototype`
7. open the `requirements.txt` file and copy the line you added for your repo (*e.g.*, `-e git+https://github.com/MidAtlanticPortal/new_repo.git@master#egg=an_alias`)
8. enter `pip install` and paste (*e.g.*,`pip install -e git+https://github.com/MidAtlanticPortal/new_repo.git@master#egg=an_alias` ) and run
9. navigate to `cd ~/webapps/marco_portal/marco`
10. run `python manage.py collectstatic -i utfgrid`
11. run `python manage.py compress`
12. restart the server - `~/webapps/marco_portal/apache2/bin/restart`  
