
scripted_framework_output_root_directory="$GOPATH/src"
NAME_THIS_OUTPUT_DIRECTORY="$scripted_framework_output_root_directory/main/java"

java_class_model_files_directory="$scripted_framework_output_root_directory/main/java/Model"

ftl_file_output_directory="$scripted_framework_output_root_directory/main/resources/TemplateEngine"

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
    
    
    # Create array of config files.
    config_files_arr=($class_configs_dir/*)

    # Create files from each config file.
    for ((config_file_array_index=0; config_file_array_index<${#config_files_arr[@]}; config_file_array_index++)); do
        create_jave_class_config_array_from_file ${config_files_arr[config_file_array_index]}
        parse_config_lines_in_file_into_java_class_build_variables
  
        # Create Java Class File !! THIS NEEDS TO BE EXPLAINED BETTER!      
        source $support_scripts_dir/generate_basic_java_file_from_vars.bash

        #mkdir -p $java_files_output_directory_name
        
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
        
        # Create Java Model Files.
        java_class_model_files_directory_and_name_one="$java_class_model_files_directory/Model.java"
        java_class_model_files_directory_and_name_two="$java_class_model_files_directory/UserTable.java"
        source $support_scripts_dir/generate_java_model_files_from_vars.bash
        
        create_java_model_files
        
        # Create FreeMarker templet for Create Form.
        ftl_files_output_directory_and_file_name="$ftl_file_output_directory/createForm.ftl"
        source $support_scripts_dir/generate_create_form_ftl_file_from_vars.bash
        
        add_header_to_ftl_file
        
        for ((attribute_array_index=0;attribute_array_index<${#java_class_attribute_array[@]};attribute_array_index++)); do
            create_attribute_array_split
            add_attribute_set_form_field_to_ftl_file
        done        
        
        add_footer_to_ftl_file
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

        atribute_text_for_label="${attribute_array_split[3]}"
        atribute_text_for_placeholder="${attribute_array_split[4]}"
}

function parse_config_lines_in_file_into_java_class_build_variables(){

    start_index_for_class_attributes_array_offset=2
    start_index_for_class_attributes=$start_index_for_class_attributes_array_offset
    end_index_for_class_attributes=$((${#class_configs_lines[@]}-1))
    
    java_package_for_class=$(printf "%s" ${class_configs_lines[0]})
    
    java_class_name=$(printf "%s" ${class_configs_lines[1]})
    java_class_name_lower_case=$(printf "%s" ${class_configs_lines[1]})
    java_class_name_lower_case="$(tr '[:upper:]' '[:lower:]' <<< ${java_class_name_lower_case:0:1})${java_class_name_lower_case:1}"
    
    
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

function run_diff_test(){
    diff_test_results=$(diff -r src/ x_diffs/src_original/)
    printf "\nDIFF TEST RESULTS!\n\n"
    if [ "$diff_test_results" != "" ] 
    then
        printf "%s" "$diff_test_results"
        echo "The directory was modified"
    else
        printf "%s\n" "None"
    fi
    printf "\n---- END of RESULTS ----\n\n"
}

function delete_created_boilerplate(){
    read -p "Are you sure? (Y/n) " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Y]$ ]]
    then
        rm -rf $scripted_framework_output_root_directory
    fi    
}
spark_framework_haos_bash
run_diff_test

