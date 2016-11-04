
#source $script_dir/set_location_vars.bash

function show_directory_structure_to_create(){
    printf "ROOT : %s\n" $scripted_framework_output_root_directory
}

function make_spark_framework_directory_structure(){

    mkdir -p $scripted_framework_output_root_directory
    mkdir -p $NAME_THIS_OUTPUT_DIRECTORY
    mkdir -p $ftl_file_output_directory
    mkdir -p $java_class_model_files_directory
    
}

#show_directory_structure_to_create
make_spark_framework_directory_structure

