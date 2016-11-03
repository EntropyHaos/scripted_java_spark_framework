: << 'EOC'

script_dir="z_haos"
export script_dir

readarray entitys_atributes < $1

bash $script_dir/make_frameworks_dir_structure.bash

bash $script_dir/generate_entity_class_file_n_code_it.bash "${entitys_atributes[@]}"
bash $script_dir/generate_entity_insert_ftl_template.bash "${entitys_atributes[@]}"



EOC

scripted_framework_output_root_directory="$GOPATH/src"

driver_script_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
framework_support_files_directory="$driver_script_directory/framework_support"
support_scripts_dir="$framework_support_files_directory/bash_scripts"
class_configs_dir="$framework_support_files_directory/class_configs"

function display_basic_script_info(){
    echo "Support scripts directory : $support_scripts_dir"
    echo "Class configs directory : $support_configs_dir"
    
}

function display_java_class_config_file_lines(){
    
    for config_line in "${class_configs_lines[@]}"
    do
        printf "%s" "$config_line"
    done
}

function display_java_class_config_variables(){
    printf "\nJava Class Config Variables\n\n"
    printf "Class Name : %s\n" "$java_class_name"
    
    
    
    printf "Class Creator : %s\n" "$java_class_creator"
}
function create_files_from_java_class_configs(){
    
    config_files_arr=($class_configs_dir/*)
    #echo "There are ${#config_files_arr[@]} java config files."
    
    for ((config_file_array_index=0; config_file_array_index<${#config_files_arr[@]}; config_file_array_index++)); do
        #echo "File $(($config_file_array_index+1)) to parse : ${config_files_arr[config_file_array_index]}"
        create_jave_class_config_array_from_file ${config_files_arr[config_file_array_index]}
        #display_java_class_config_file_lines
        parse_config_lines_in_file_into_java_class_build_variables
    done    
}

function parse_config_lines_in_file_into_java_class_build_variables(){
    
    #echo "There are ${#class_configs_lines[@]} lines to parse."
    
    start_index_for_class_atributes_array_offset=1
    start_index_for_class_atributes=$start_index_for_class_atributes_array_offset
    end_index_for_class_atributes=$((${#class_configs_lines[@]}-1))
    
    java_class_name=${class_configs_lines[0]}
    
    for ((java_class_atribute_index=$((start_index_for_class_atributes)); java_class_atribute_index<$(($end_index_for_class_atributes));java_class_atribute_index++)); do
        
        echo "Atribute #$java_class_atribute_index"
    done
    
    
    java_class_creator=${class_configs_lines[end_index_for_class_atributes]}
    
    
    #display_java_class_config_variables
    : << 'EOF'
    
    for ((class_configs_lines_array=0; class_configs_lines_array<${#class_configs_lines[@]}; class_configs_lines_array++)); do
        printf "%s" "${class_configs_lines[class_configs_lines_array]}"
        #create_jave_class_config_array_from_file ${config_files_arr[i]}
        #display_java_class_config_file_lines
        #parse_config_lines_in_file_into_java_class_build_array
    done    
EOF
}

function create_jave_class_config_array_from_file(){
    java_class_config_file=$1
    readarray class_configs_lines < $java_class_config_file
    
}

function spark_framework_haos_bash(){
    create_files_from_java_class_configs;
}

spark_framework_haos_bash


: << 'EOF'
    for config_line in "${class_configs_lines[@]}"
    do
        printf "%s" "$config_line"
    done

function test_setup(){
    bash $support_scripts_dir/test.bash
    bash $class_configs_dir/test.bash
    
}

EOF