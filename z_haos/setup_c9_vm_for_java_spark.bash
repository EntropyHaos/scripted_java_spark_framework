# This a simple script used to setup a Cloud9 VM.

# ToDo add function to delete script after its been run.

function init() {
    get_confirmation;
    setup_cloud9_vm_for_spark_framework;
}

function get_confirmation(){
    clear
    echo_action "You are about to install Java8 and Maven on this machine." true
    read -p "Do you want to do this? " -n 1 -r
    echo    # move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo_action "Installation will start in 2 seconds." true
    else
        exit;
    fi
    sleep 2  # Waits 2 seconds.
    clear
}

function setup_cloud9_vm_for_spark_framework() {
    echo_action "Adding external APT repository." true
    sudo add-apt-repository ppa:webupd8team/java -y
    echo_action "Downloading package lists from the repositories and updating them." true
    sudo apt-get update
    echo_action "Installing Java Installer." true
    sudo apt-get install oracle-java8-installer -y
    echo_action "Setting default Java to Java8" true
    sudo apt-get install oracle-java8-set-default -y
    echo_action "Installing Maven" true
    sudo apt-get install maven -y
}

function create_line_across_terminal() {
    echo
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo
}

function echo_action() {
    if [ "$2" = true ]
    then
        create_line_across_terminal
        echo "$1"
        create_line_across_terminal
    else
        echo ""
        echo "$1"
        echo ""
    fi
}

function delete_this_script() {
    directory_script_is_run_from="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    script_name=`basename "$0"`
    cd $directory_script_is_run_from
    rm $script_name
}

init
delete_this_script