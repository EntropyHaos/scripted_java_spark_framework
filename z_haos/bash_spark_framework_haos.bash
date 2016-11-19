function all_vars_set(){
    driver_script_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    
    scripts_built_for_diff_compare="$driver_script_directory/../x_diffs"
    
    scripts_build_dir="$GOPATH/a_build"
    scripted_framework_output_root_directory="$scripts_build_dir/src"
    
    java_files_src_directory="$scripted_framework_output_root_directory/main/java"

    java_driver_files_location="$java_files_src_directory/drivers"
    java_driver_files_location_and_name="$java_driver_files_location/Application.java"

    java_class_model_files_directory="$scripted_framework_output_root_directory/main/java/models"
    ftl_file_output_directory="$scripted_framework_output_root_directory/main/resources/templateEngine"

    spring_framework_interface_files_directory="$java_files_src_directory/repositories"
    
    framework_support_files_directory="$driver_script_directory/framework_support"
    framework_boilerplate_files="$framework_support_files_directory/y_boilerplate"
    support_scripts_dir="$framework_support_files_directory/bash_scripts"
    class_configs_dir="$framework_support_files_directory/class_configs"
    
    config_files_arr=(); # Array of config files used.
    create_config_file_array; # Sets array.
    
    config_file_name_with_out_extension_array=(); # Similiar to above.
    create_config_file_name_with_out_extension_array;
    
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

function TODO(){
    : << 'EOTODO'
    
    TODO : Rename functions into predictable format.
            * display is for console display and used mostly for testing.
            * create should be limited to internal operations.
            * generate should be for file creation.
    
    TODO : Organize the vars to be more maintainable.
    
    TODO : Figure out how to not need the indentation for skiped lines.
    
    TODO : ...BP...
    
EOTODO
    
    # TODO : THIS!!! (not now though.)
    if [ "$display_to_for_scripts" = "true" ]
    then
    echo "ToDo list: "
    else
    echo "ToDo list skipped."
    fi
}

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

function create_jave_class_config_array_from_file(){
    java_class_config_file=$1
    readarray class_configs_lines < $java_class_config_file
}

function create_config_file_array(){
    # Create array of config files.
    config_files_arr=($class_configs_dir/*)
}

function create_config_file_name_with_out_extension_array(){
    local var;
    
    local index=0;
    
    for var in ${config_files_arr[@]}
    do
        file_path=${var%/*}
        file_full_name=${var##*/}
        file_just_name=${file_full_name%.*}
        file_extension=${file_full_name##./}
        
        config_file_name_with_out_extension_array[index]=$file_just_name
        let "index=$index+1"

: << 'EOC'
        printf "%s\n" $index
        printf "%s\n" $file_path
        printf "%s\n" $file_full_name
        printf "%s\n" $file_just_name
        printf "%s\n" $file_extension
EOC
    done
    
    #printf "Number of elements in array = %s\n" "${#config_file_name_with_out_extension_array[@]}"
}

function delete_existing(){
    rm -rf $scripts_build_dir
}

function delete_created_boilerplate_with_prompt(){
    read -p "Delete Creation? (y/n) " -n 1 -r
    echo    # move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        rm -rf $scripts_build_dir
    fi    
}

function diff_test_entire_build_verbose(){
    diff_test_results=$(diff -r $scripts_build_dir/ $scripts_built_for_diff_compare/)
    printf "\nDIFF TEST RESULTS!\n\n"
    if [ "$diff_test_results" != "" ] 
    then
        printf "%s\n" "$diff_test_results"
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

function generate_maven_pom_file(){
    source $support_scripts_dir/generate_maven_files.bash
    create_pom_file
}

function parse_config_lines_in_file_into_java_class_build_variables(){

    start_index_for_class_attributes_array_offset=2
    start_index_for_class_attributes=$start_index_for_class_attributes_array_offset
    end_index_for_class_attributes=$((${#class_configs_lines[@]}-1))
    
    java_package_for_class=$(printf "%s" ${class_configs_lines[0]})
    
    java_class_name=$(printf "%s" ${class_configs_lines[1]})
    java_class_name_lower_case=$(printf "%s" ${class_configs_lines[1]})
    java_class_name_lower_case="$(tr '[:upper:]' '[:lower:]' <<< ${java_class_name_lower_case:0:1})${java_class_name_lower_case:1}"
    
    #driver_config_entities+=($java_class_name)
    
    java_class_file_name=$(printf "%s.java" $java_class_name)
    
    java_files_output_directory_name=$java_files_src_directory/$java_package_for_class
    java_files_output_directory_and_file_name=$java_files_output_directory_name/$java_class_file_name
    
    java_class_attribute_array=()
    for ((java_class_attribute_index=$((start_index_for_class_attributes)); java_class_attribute_index<$(($end_index_for_class_attributes));java_class_attribute_index++)); do
        
        java_class_attribute_array[$((java_class_attribute_index-start_index_for_class_attributes_array_offset))]=${class_configs_lines[java_class_attribute_index]}
    done
    
    java_class_generator_name=${class_configs_lines[end_index_for_class_attributes]}
}

function generate_files_from_java_class_configs(){
    
    # Create files from each config file.
    for ((config_file_array_index=0; config_file_array_index<${#config_files_arr[@]}; config_file_array_index++)); do
        
        create_jave_class_config_array_from_file ${config_files_arr[config_file_array_index]}
        parse_config_lines_in_file_into_java_class_build_variables

        # Create basic Java File.
        source $support_scripts_dir/generate_basic_java_file_from_vars.bash
        create_java_file

        # Create Java Model Files. Used in Previous version of script...
        #source $support_scripts_dir/generate_java_model_files_from_vars.bash
        #create_java_model_files
        
        # Create Spring Framework repository Interface Files.
        source $support_scripts_dir/generate_spring_framework_interface_file_from_vars.bash
        spring_framework_interface_file
        
        # Create FreeMarker templet Create Form for entitity.
        source $support_scripts_dir/generate_ftl_create_entity_form.bash
        create_create_entity_ftl_file
        
        # Create FreeMarker templet Create Entity Form for entitity.
        source $support_scripts_dir/generate_ftl_show_entity.bash
        create_show_entity_ftl_file
        
        # Create FreeMarker templet Update Entity Form for entitity.
        source $support_scripts_dir/generate_ftl_update_entity_form.bash
        create_update_entity_ftl_file
        
        # Create FreeMarker templet Remove Entity Form for entitity.
        source $support_scripts_dir/generate_ftl_remove_form.bash
        create_remove_ftl_file
    done
    generate_java_driver_file
    generate_main_ftl_file
}

function generate_driver_file(){
    source $support_scripts_dir/generate_java_driver_file.bash
    create_java_file
}

function generate_java_driver_file(){
    source $support_scripts_dir/generate_java_driver_file.bash
    
    add_header_to_java_main_file
    

    for ((config_file_array_index=0; config_file_array_index<${#config_files_arr[@]}; config_file_array_index++)); do
        
        create_jave_class_config_array_from_file ${config_files_arr[config_file_array_index]}
        parse_config_lines_in_file_into_java_class_build_variables
        add_model_decleration
    done
    
    add_mongo_db_controller_decleration
    add_main_method
    add_run_method
    add_begining_to_Server_start_method
    add_root_route
    
    for ((config_file_array_index=0; config_file_array_index<${#config_files_arr[@]}; config_file_array_index++)); do
        
        create_jave_class_config_array_from_file ${config_files_arr[config_file_array_index]}
        parse_config_lines_in_file_into_java_class_build_variables
        add_get_and_post_to_java_main_file
    done
    
    add_footer_to_java_main_file
}

function generate_main_ftl_file(){
    source $support_scripts_dir/generate_ftl_main_file.bash
    ftl_files_output_directory_and_main_ftl_file_name="$ftl_file_output_directory/aMain.ftl"
    
    #display_vars_for_generate_main_ftl_file
    add_header_to_main_ftl_file
    

    for ((config_file_array_index=0; config_file_array_index<${#config_files_arr[@]}; config_file_array_index++)); do
        
        create_jave_class_config_array_from_file ${config_files_arr[config_file_array_index]}
        parse_config_lines_in_file_into_java_class_build_variables
        add_entity_manage_menu_to_main_ftl_file
    done
    
    add_footer_to_main_ftl_file
    : << 'EOF'
EOF
    
}

function spark_framework_haos_bash(){
    
    generate_files_from_java_class_configs;
}

all_vars_set
delete_existing
copy_static_files

copy_files_needing_abstraction
spark_framework_haos_bash
generate_maven_pom_file
#diff_test_entire_build_verbose
#diff_test_entire_build_not_verbose

function prompt_for_clean_and_install(){
    read -p "Perform Maven Clean and Install? (y/n) " -n 1 -r
    echo    # move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        #rm -rf $scripts_build_dir
        cd $scripts_build_dir
        mvn clean install
        cd $GOPATH
    fi    
}
# prompt_for_clean_and_install
delete_created_boilerplate_with_prompt

: << 'EOP' # EOP is a 'pause' used for dev. and testing. Should be removed.
EOP

: << 'ENDofTESTINGcommands' # These are commented out but useful for the tool.
all_vars_set

function test_generate_java_file_boilerplate(){
    source $framework_boilerplate_files/BP_generate_java_file.bash
    create_java_file
}
test_generate_java_file_boilerplate


ENDofTESTINGcommands

#diff_test_entire_build_not_verbose
#diff_test_model_verbose
