# TODO : Make it record times and other stuff(s)?

function init()
{
    echo_action "Setup Configs for Silent Java Install" true
    setup_configs_for_silent_java_sdk_install
    echo_action "Setup Spark Framework on Cloud9" true
    setup_cloud9_vm_for_spark_framework
}

function setup_configs_for_silent_java_sdk_install(){
    echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
    echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
}

function setup_cloud9_vm_for_spark_framework()
{
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
    : << 'EOP'
EOP
}

function create_line_across_terminal()
{
    echo
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo
}

function echo_action()
{
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

function run_test()
{
    echo "test completed."
}

function run_silent_install_of_framework(){
    # It's so easy...
    log_dir="log_haos"
    # Move to C9 project root.
    cd $GOPATH
    # Go one directory up.
    cd ..
    # Make the logfile directory if it is not there.
    mkdir -p $log_dir
    # Drop down into it.
    cd $log_dir
    # Set the name for the log file.
    log_file="spark_framework_install.txt"
    # Run the setup script and append write to log file.
    
    # This runs the setup with no output to console logging to file.
    #init >> "$log_file" 2>&1
    # This works for logging and viewing install at the same time.
    init | tee -a "$log_file"
    
    # Go back to the project's root directory.
    cd $GOPATH
}

function delete_this_script() {
    directory_script_is_run_from="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    script_name=`basename "$0"`
    cd $directory_script_is_run_from
    rm $script_name
}
# run_silent_install_of_framework

delete_this_script;