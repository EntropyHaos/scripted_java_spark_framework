
#source $script_dir/set_location_vars.bash

function show_directory_structure_to_create(){
    printf "ROOT : %s\n" $scripted_framework_output_root_directory
}

function make_spark_framework_directory_structure(){

    #mkdir -p $scripted_framework_output_root_directory
    mkdir -p $NAME_THIS_OUTPUT_DIRECTORY
    
: << 'EOC'

    
    mkdir -p $apps_java_junit_test_case_location
    
    mkdir -p $apps_static_js_files
    mkdir -p $apps_static_css_files
    mkdir -p $apps_static_template_engine_files
EOC
}

#show_directory_structure_to_create
make_spark_framework_directory_structure

