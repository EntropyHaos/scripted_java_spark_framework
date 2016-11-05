scripts_build_dir="$GOPATH/a_build"
scripts_built_for_diff_compare="$GOPATH/x_diffs"
scripted_framework_output_root_directory="$scripts_build_dir/src"

java_files_src_directory="$scripted_framework_output_root_directory/main/java"

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
    
    java_files_output_directory_name=$java_files_src_directory/$java_package_for_class
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

function create_files_from_java_class_configs(){
    
    # Create array of config files.
    config_files_arr=($class_configs_dir/*)

    # Create files from each config file.
    for ((config_file_array_index=0; config_file_array_index<${#config_files_arr[@]}; config_file_array_index++)); do
        
        create_jave_class_config_array_from_file ${config_files_arr[config_file_array_index]}
        parse_config_lines_in_file_into_java_class_build_variables

        # Create basic Java File.
        source $support_scripts_dir/generate_basic_java_file_from_vars.bash
        create_java_file

        # Create Java Model Files.
        source $support_scripts_dir/generate_java_model_files_from_vars.bash
        create_java_model_files
        
        # Create FreeMarker templet for Create Form.
        source $support_scripts_dir/generate_create_form_ftl_file_from_vars.bash
        create_create_ftl_file
    done    
}

function spark_framework_haos_bash(){
    
    create_files_from_java_class_configs;
}

function delete_existing(){
    rm -rf $scripts_build_dir
}

function diff_test_entire_build_verbose(){
    diff_test_results=$(diff -r $scripts_build_dir/ $scripts_built_for_diff_compare/)
    printf "\nDIFF TEST RESULTS!\n\n"
    if [ "$diff_test_results" != "" ] 
    then
        printf "%s" "$diff_test_results"
        echo "The directory was modified"
    printf "\n---- END of RESULTS ----\n\n"
    else
        printf "%s\n" "None"
        printf "\n---- END of RESULTS ----\n\n"
        #delete_created_boilerplate_with_prompt
        
    fi
}

function diff_test_entire_build_not_verbose(){
    diff_test_results=$(diff -r --brief $scripts_build_dir/ $scripts_built_for_diff_compare/)
    printf "\nDIFF TEST RESULTS!\n\n"
    if [ "$diff_test_results" != "" ] 
    then
        printf "%s" "$diff_test_results"
        echo "The directory was modified"
    printf "\n---- END of RESULTS ----\n\n"
    else
        printf "%s\n" "None"
        printf "\n---- END of RESULTS ----\n\n"
    fi
}

function diff_test_model_verbose(){
    diff_test_results=$(diff -r $scripts_build_dir/src/main/java/Model $scripts_built_for_diff_compare/src/main/java/Model)
    printf "\nDIFF TEST RESULTS!\n\n"
    if [ "$diff_test_results" != "" ] 
    then
        printf "%s" "$diff_test_results"
        echo "The directory was modified"
    printf "\n---- END of RESULTS ----\n\n"
    else
        printf "%s\n" "None"
        printf "\n---- END of RESULTS ----\n\n"
        
    fi
}

function delete_created_boilerplate_with_prompt(){
    read -p "Delete Creation?(y/n) " -n 1 -r
    echo    # move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        rm -rf $scripts_build_dir
    fi    
}

function copy_static_files(){
    dir_to_copy_from="$framework_support_files_directory/z_statics_for_copy"
    dir_to_copy_to="$scripts_build_dir"
    cp -R $dir_to_copy_from/. $dir_to_copy_to/
}

function copy_files_needing_abstraction(){
    dir_to_copy_from="$framework_support_files_directory/z_copy_but_need_abstraction"
    dir_to_copy_to="$scripts_build_dir"
    cp -R $dir_to_copy_from/. $dir_to_copy_to/
}

delete_existing
copy_static_files
copy_files_needing_abstraction
spark_framework_haos_bash
diff_test_entire_build_verbose
delete_created_boilerplate_with_prompt

#diff_test_entire_build_not_verbose
#diff_test_model_verbose
