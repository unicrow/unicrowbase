#!/bin/bash

echo -e -n """\033[0;96m
||    ||  ||    ||  ||  ||||||||  ||||||    ||||||   ||    ||    ||
||    ||  ||||  ||  ||  ||        ||   ||  ||    ||   ||  ||||  ||
||    ||  ||  ||||  ||  ||        |||||    ||    ||    ||||  ||||
||||||||  ||    ||  ||  ||||||||  ||   ||   ||||||      ||    ||
\033[0;97m"""


read -p """
Welcome Unicrowbase :)

Django: 1
Sass  : 2
Exit  : 0

Which project are started? [Enter]: """ state
case $state in
    [1]* ) echo -e "\n---   Django   ---\n";;
    [2]* ) echo -e "\n---    Sass    ---\n";;
    [0]* ) exit;;
    * ) exit;;
esac

base_dir=`pwd`

if [ $state -eq 1 ]
then

  ###   Django   ###

  while true; do
    # Project Name
    while true; do
      read -p "What is the name of project? (project_name, home/user/project_name): " project_name
      if [ $project_name ]
      then
        break;
      else
        echo "Please enter a project name!"
      fi
    done

    # Python Version
    while true; do
      read -p "Which version are you using python? ( [python3]/python2 ): " python_version
      case $python_version in
          [python2]* ) python_version=${python_version:-python2}; break;;
          * ) python_version=${python_version:-python3}; break;;
      esac
    done

    # Django Version
    read -p "Which version are you using django? (default latest version): " django_version
    django_version=${django_version:-latest}

    # Remote Address
    read -p "Remote address? (Optional, example: https://github.com/unicrow/unicrowbase.git): " remote_address

    echo -e "\n------------------\n"
    read -p """Project Name = $project_name
Python Version = $python_version
Django Version = $django_version
Remote Address = $remote_address
Do yu confirm? ([Y]/N): """ confirm
    case $confirm in
        [Nn]* ) echo -e "\n------------------\n"; echo -e "Start from beginning!\n";;
        * ) break;;
    esac
  done

  if [ -d "$project_name" ]
  then
    while true; do
      read -p "The project already exist! Did you overwrite? ( [N]/Y ): " remove_project
      case $remove_project in
        [Yy]* ) rm -rf $project_name; break;;
        * ) echo -e "\n------------------\n"; echo -e "Installation aborted!\n"; exit;;
      esac
    done
  fi

  echo -e "\n---   Setup Begins   ---\n"

  # First Step #
  echo -e "\n---  First Step   ---\n"
  rm -rf unicrowbase_settings
  git clone https://gist.github.com/12427dc80be9cf1af2f773c50f5c9758.git unicrowbase_settings
  ##############

  { # try

    # Create Virtualenv #
    echo -e "\n---  Create Virtualenv   ---\n"
    mkdir $project_name; cd $project_name; mkdir backup log conf
    virtualenv -p $python_version web/env; cd web; source env/bin/activate
    #####################


    # Install Django #
    echo -e "\n---  Install Django   ---\n"
    { # try
      pip install Django==$django_version
    } || { # catch
      pip install Django
    }
    ##################


    # Start Project #
    echo -e "\n---  Start Project   ---\n"
    django-admin startproject source; cd source;
    ##################


    # Configure Remote Address #
    if [ $remote_address ]
    then
      echo -e "\n---  Configure Remote Address   ---\n"
      git init; git remote add origin $remote_address
    fi
    ############################


    # Configure Project #
    cd source; mkdir apps templates templatetags settings

    # Apps
    cd apps; $base_dir/$project_name/web/source/manage.py startapp core; mv ../urls.py core/

    # Templatetags
    cd ..; touch templatetags/__init__.py

    # Settings
    echo -e "\n---  Configure Project   ---\n"
    cp $base_dir/unicrowbase_settings/settings_init.py settings/
    mv settings/settings_init.py settings/__init__.py
    mv settings.py settings/
    mv settings/settings.py settings/base.py
    sed -i -e 's/source.urls/source.apps.core.urls/g' settings/base.py
    echo -e "\n---     End Setup    ---\n"
    #####################

  } || { # catch
    cd $base_dir
    rm -rf $project_name
    echo -e "\n------------------\n"; echo -e "An error occurred. Installation aborted!\n";
  }

  #####################

  rm -rf $base_dir/unicrowbase_settings
  deactivate

  ##################

elif [ $state -eq 2 ]
then

  ###    Sass    ###

  while true; do
    # Project Name
    while true; do
      read -p "What is the name of project? (project_name, home/user/project_name): " project_name
      if [ $project_name ]
      then
        break;
      else
        echo "Please enter a project name!"
      fi
    done

    # Sassbase Version
    while true; do
      read -p "Which version are you using sassbase? ( [include]/bower/default ): " sassbase_version
      case $sassbase_version in
          [default]* ) sassbase_version=${sassbase_version:-master}; break;;
          [bower]* ) sassbase_version=${sassbase_version:-bower}; break;;
          * ) sassbase_version=${sassbase_version:-include}; break;;
      esac
    done

    # Remote Address
    read -p "Remote address? (Optional, example: https://github.com/unicrow/unicrowbase.git): " remote_address

    echo -e "\n------------------\n"
    read -p """Project Name = $project_name
Sassbase Version = $sassbase_version
Remote Adress = $remote_address
Do yu confirm? ([Y]/N): """ confirm
    case $confirm in
        [Nn]* ) echo -e "\n------------------\n"; echo -e "Start from beginning!\n";;
        * ) break;;
    esac
  done

  if [ -d "$project_name" ]
  then
    while true; do
      read -p "The project already exist! Did you overwrite? ( [N]/Y ): " remove_project
      case $remove_project in
        [Yy]* ) rm -rf $project_name; break;;
        * ) echo -e "\n------------------\n"; echo -e "Installation aborted!\n"; exit;;
      esac
    done
  fi

  echo -e "\n---   Setup Begins   ---\n"

  { # try

    # First Step #
    echo -e "\n---  First Step   ---\n"
    {
      git clone --branch=$sassbase_version https://github.com/unicrow/sassbase.git $project_name
    } || {
      git clone https://github.com/unicrow/sassbase.git $sassbase_version
      echo -e "\nVersion not found! Pull default version.\n"
    }
    ##############


    # Configure Remote Address #
    cd $project_name; rm -rf .git/
    if [ $remote_address ]
    then
      echo -e "\n---  Configure Remote Address   ---\n"
      git init; git remote add origin $remote_address
    fi
    ############################


    # Install Npm Packages #
    echo -e "\n---  Install Npm Packages   ---\n"
    npm install
    ########################


    echo -e "\n---     End Setup    ---\n"


    # Start Grunt #
    echo -e "\n---     Start Grunt    ---\n"
    grunt
    ###############

  } || { # catch
    cd $base_dir
    rm -rf $project_name
    echo -e "\n------------------\n"; echo -e "An error occurred. Installation aborted!\n";
  }

else
  exit
fi
