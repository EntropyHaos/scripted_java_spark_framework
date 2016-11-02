
source $script_dir/set_location_vars.bash

function make_spark_framework_directory_structure(){

    mkdir -p $apps_entity_package_location
    
    mkdir -p $apps_java_junit_test_case_location
    
    mkdir -p $apps_static_js_files
    mkdir -p $apps_static_css_files
    mkdir -p $apps_static_template_engine_files
}

make_spark_framework_directory_structure

