#!/bin/bash

echo -e -n """\033[0;96m
||    ||  ||    ||  ||  ||||||||  ||||||    ||||||   ||    ||    ||
||    ||  ||||  ||  ||  ||        ||   ||  ||    ||   ||  ||||  ||
||    ||  ||  ||||  ||  ||        |||||    ||    ||    ||||  ||||
||||||||  ||    ||  ||  ||||||||  ||   ||   ||||||      ||    ||
\033[0;97m"""


read -p """
Welcome Unicrowbase :)

Start Django Project : 1
Start Sass Project   : 2
Exit                 : 0

Which project are started? [Enter]: """ start_state
case $start_state in
    [1]* ) echo -e "\n---   Django Project  ---\n";;
    [2]* ) echo -e "\n---    Sass Project   ---\n";;
    [3]* ) echo -e "\n--- Sass Requirements ---\n";;
    [0]* ) exit;;
    * ) exit;;
esac

base_dir=`pwd`
OS=`uname`
echo -e "\033[0;32mOS: $OS\033[0;97m"
echo -e "\n-------------------------\n"

if [ $start_state -eq 1 ]; then

  ###   Django   ###

  while true; do
    echo -e "\n---    First Step   ---\n"

    # Project Name
    while true; do
      read -p "What is the name of project? (project_name, home/user/project_name): " project_name
      if [ $project_name ]; then
        break;
      else
        echo "Please enter a project name!"
      fi
    done

    # Python Version
    echo "Which version are you using python? (Type: 1 or 2)"
    select python_version in "python3" "python2"; do
       case $python_version in
           python2 ) python_version=${python_version:-python2}; break;;
           python3 ) python_version=${python_version:-python3}; break;;
       esac
    done

    # Django Version
    read -p "Which version are you using django? (default latest version): " django_version
    django_version=${django_version:-latest}

    # Remote Address
    read -p "Remote address? (Optional, example: https://github.com/unicrow/unicrowbase.git): " remote_address

    echo -e "\n-----------------------\n"
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

  if [ -d $project_name ]; then
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
  echo -e "\n---  Clone Code   ---\n"
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
    git init
    if [ $remote_address ]; then
      echo -e "\n---  Configure Remote Address   ---\n"
      git remote add origin $remote_address
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

elif [ $start_state -eq 2 ]; then

  ###    Sass    ###

  # Control Package #
  while true; do
    echo -e "\n---   Packages Being Checked   ---\n"

    package=True
    package_ruby=True
    package_brew=True
    package_npm=True
    package_bower=True
    package_grunt=True

    {
      ruby --version >/dev/null 2>&1 && echo -en "* \033[0;32mRuby (`ruby --version`)\033[0;97m\n"
    } || {
      package=False
      package_ruby=False
      echo -en "* \033[0;31mRuby \033[0;97m\n"
    }

    {
      brew --version >/dev/null 2>&1 && echo -en "* \033[0;32mBrew (`brew --version`)\033[0;97m\n"
    } || {
      package=False
      package_brew=False
      echo -en "* \033[0;31mBrew \033[0;97m\n"
    }

    {
      npm --version >/dev/null 2>&1 && echo -en "* \033[0;32mNpm (`npm --version`)\033[0;97m\n"
    } || {
      package=False
      package_npm=False
      echo -en "* \033[0;31mNpm \033[0;97m\n"
    }

    {
      bower --version >/dev/null 2>&1 && echo -en "* \033[0;32mBower (`bower --version`)\033[0;97m\n"
    } || {
      package=False
      package_bower=False
      echo -en "* \033[0;31mBower \033[0;97m\n"
    }

    {
      grunt --version >/dev/null 2>&1 && echo -en "* \033[0;32mGrunt (`grunt --version`)\033[0;97m\n"
    } || {
      package=False
      package_grunt=False
      echo -en "* \033[0;31mGrunt \033[0;97m\n"
    }

    echo -e "\n----------------------------\n"

    if [ $package == False ]; then

      read -p "Is missing packages are installed?? ( [Y]/N ): " package_state
      case $package_state in
          [Nn]* ) echo -e "\nInstallation aborted!\n"; exit;;
          * ) echo "";;
      esac

      # Ruby #
      if [ $package_ruby == False ]; then
        echo -e "\n---     Ruby     ---\n"
        wget "https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.1.tar.gz"
        tar -xvf ruby-2.3.1.tar.gz >/dev/null 2>&1; cd ruby-2.3.1
        ./configure
        make
        sudo make install
        echo -e "\n--------------------\n"
        rm -rf ruby-2.3.1
        rm -rf ruby-2.3.1.tar.gz
      fi
      ########

      # Brew #
      if [ $package_brew == False ]; then
        echo -e "\n---     Brew    ---\n"
        if [ $OS == 'Linux' ]; then
          ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
          PATH="$HOME/.linuxbrew/bin:$PATH"
        elif [ $OS == 'Darwin' ]; then
          /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi
        echo -e "\n--------------------\n"
      fi
      ########

      # Npm #
      if [ $package_npm == False ]; then
        echo -e "\n---     Npm     ---\n"
        brew install node
        echo -e "\n--------------------\n"
      fi
      #######

      # Bower #
      if [ $package_bower == False ]; then
        echo -e "\n---    Bower     ---\n"
        npm install -g bower
        echo -e "\n--------------------\n"
      fi
      #######

      # Grunt #
      if [ $package_grunt == False ]; then
        echo -e "\n---    Grunt     ---\n"
        npm install -g grunt-cli
        echo -e "\n--------------------\n"
      fi
      #########

    else
      break;
    fi

    rm -rf npm-debug.log

  done

  if [ $package == True ]; then

    while true; do
      echo -e "\n---    First Step   ---\n"
      # Project Name
      while true; do
        read -p "What is the name of project? (project_name, home/user/project_name): " project_name
        if [ $project_name ]; then
          break;
        else
          echo "Please enter a project name!"
        fi
      done

      # Sassbase Version
      echo "Which version are you using sassbase? ( Type: 1 or 2 ) "
      select sassbase_version in "include" "default"; do
        case $sassbase_version in
            default ) sassbase_version=stable-default; break;;
            include ) sassbase_version=stable-include; break;;
        esac
      done

      # Remote Address
      read -p "Remote address? (Optional, example: https://github.com/unicrow/unicrowbase.git): " remote_address

      echo -e "\n-----------------------\n"
      read -p "Project Name = $project_name
Sassbase Version = $sassbase_version
Remote Adress = $remote_address
Do yu confirm? ([Y]/N): """ confirm
      case $confirm in
          [Nn]* ) echo -e "\n------------------\n"; echo -e "Start from beginning!\n";;
          * ) break;;
      esac
    done

    if [ -d "$project_name" ]; then
      while true; do
        read -p "The project already exist! Did you overwrite? ( [N]/Y ): " remove_project
        case $remove_project in
          [Yy]* ) rm -rf $project_name; break;;
          * ) echo -e "\n------------------\n"; echo -e "Installation aborted!\n"; exit;;
        esac
      done
    fi

    echo -e "\n\n---   Setup Begins   ---\n"

    { # try

      # First Step #
      echo -e "\n---  Clone Code   ---\n"
      {
        git clone --branch=$sassbase_version https://github.com/unicrow/sassbase.git $project_name
      } || {
        git clone --branch=stable-include https://github.com/unicrow/sassbase.git $project_name
        echo -e "\nVersion not found! Pull default version.\n"
      }
      ##############


      # Configure Remote Address #
      cd $project_name; rm -rf .git/
      git init
      if [ $remote_address ]
      then
        echo -e "\n---  Configure Remote Address   ---\n"
        git remote add origin $remote_address
      fi
      ############################


      # Install Npm Packages #
      if [ -f package.json ]; then
        echo -e "\n---  Install Npm Packages   ---\n"
        npm install
      fi
      ########################

      # Bower Packages #
      if [ -f bower.json ]; then
        echo -e "\n---  Install Bower Packages   ---\n"
        bower install
      fi
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

  fi
fi
