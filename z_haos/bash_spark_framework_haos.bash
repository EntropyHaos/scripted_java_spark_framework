: << 'EOC'

script_dir="z_haos"
export script_dir

readarray entitys_attributes < $1

bash $script_dir/make_frameworks_dir_structure.bash

bash $script_dir/generate_entity_class_file_n_code_it.bash "${entitys_attributes[@]}"
bash $script_dir/generate_entity_insert_ftl_template.bash "${entitys_attributes[@]}"



EOC

scripted_framework_output_root_directory="$GOPATH/src"
NAME_THIS_OUTPUT_DIRECTORY="$scripted_framework_output_root_directory/main/java"



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
    
    printf "Class Name : %s\n" $java_class_name
    
    for ((java_class_array_variable_index=0;java_class_array_variable_index<${#java_class_attribute_array[@]};java_class_array_variable_index++)); do
        echo ${java_class_attribute_array[java_class_array_variable_index]}
    done
    
    printf "Class Creator : %s\n" "$java_class_creator"
}

function create_files_from_java_class_configs(){
    
    #source 
    config_files_arr=($class_configs_dir/*)
    #printf "There are %s java config files." ${#config_files_arr[@]}
    #printf "\nJava Class Config Variable Sets\n\n"
    
    for ((config_file_array_index=0; config_file_array_index<${#config_files_arr[@]}; config_file_array_index++)); do
        create_jave_class_config_array_from_file ${config_files_arr[config_file_array_index]}
        parse_config_lines_in_file_into_java_class_build_variables
        
        source $support_scripts_dir/generate_basic_java_file_from_vars.bash
        
        add_header_to_java_file
        
        for ((attribute_array_index=0;attribute_array_index<${#java_class_attribute_array[@]};attribute_array_index++)); do
            create_attribute_array_split
            add_attribute_decleration_to_java_file
        done
        
        for ((attribute_array_index=0;attribute_array_index<${#java_class_attribute_array[@]};attribute_array_index++)); do
            create_attribute_array_split
            add_attribute_getter_to_java_file
            add_attribute_setter_to_java_file
        done
        
        add_footer_to_java_file
        
        #source $support_scripts_dir/generate_basic_java_file_from_vars.bash
        #display_java_class_config_variables
    done    
}

function create_attribute_array_split(){
        declare -a 'attribute_array_split=('"${java_class_attribute_array[attribute_array_index]}"')'
        
        atribute_protection_var=${attribute_array_split[0]}
        atribute_type=${attribute_array_split[1]}
        atribute_name=${attribute_array_split[2]}
        
        atribute_name_upper_case="${attribute_array_split[2]}"
        atribute_name_upper_case="$(tr '[:lower:]' '[:upper:]' <<< ${atribute_name_upper_case:0:1})${atribute_name_upper_case:1}"

}

function parse_config_lines_in_file_into_java_class_build_variables(){

    start_index_for_class_attributes_array_offset=2
    start_index_for_class_attributes=$start_index_for_class_attributes_array_offset
    end_index_for_class_attributes=$((${#class_configs_lines[@]}-1))
    
    java_package_for_class=$(printf "%s" ${class_configs_lines[0]})
    java_class_name=$(printf "%s" ${class_configs_lines[1]})
    
    java_class_file_name=$(printf "%s.java" $java_class_name)
    
    java_files_output_directory_name=$NAME_THIS_OUTPUT_DIRECTORY/$java_package_for_class
    java_files_output_directory_and_file_name=$java_files_output_directory_name/$java_class_file_name
    
    java_class_attribute_array=()
    for ((java_class_attribute_index=$((start_index_for_class_attributes)); java_class_attribute_index<$(($end_index_for_class_attributes));java_class_attribute_index++)); do
        
        java_class_attribute_array[$((java_class_attribute_index-start_index_for_class_attributes_array_offset))]=${class_configs_lines[java_class_attribute_index]}
    done
    
    java_class_generator_name=${class_configs_lines[end_index_for_class_attributes]}
    
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
    
    source $support_scripts_dir/make_frameworks_dir_structure.bash
    create_files_from_java_class_configs;
}
#clear
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