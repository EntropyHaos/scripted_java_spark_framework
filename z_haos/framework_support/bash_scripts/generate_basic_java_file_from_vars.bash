# echo $scripted_framework_output_root_directory

function display_file_creation_location_vars(){
    printf "PACKAGE : %s\n" $java_files_output_directory_name
    printf "CREATING FILE : %s\n" $java_files_output_directory_and_file_name
}

function add_header_to_java_file(){

mkdir -p $java_files_output_directory_name

cat  << EOT > $java_files_output_directory_and_file_name
package $java_package_for_class;
    
public class $java_class_name implements Validable{    
    
EOT
# Do not indent this line above here!
}

function add_attribute_decleration_to_java_file(){
    for ((attribute_array_index=0;attribute_array_index<${#java_class_attribute_array[@]};attribute_array_index++)); do
        create_attribute_array_split
        cat  << EOT >> $java_files_output_directory_and_file_name
    $atribute_protection_var $atribute_type $atribute_name;
EOT
    done
# Do not indent this line above here!
}

function add_getters_and_setters_to_java_file(){
    for ((attribute_array_index=0;attribute_array_index<${#java_class_attribute_array[@]};attribute_array_index++)); do
        create_attribute_array_split
        add_attribute_getter_to_java_file
        add_attribute_setter_to_java_file
    done        
}

function add_attribute_getter_to_java_file(){
cat  << EOT >> $java_files_output_directory_and_file_name
    
    public $atribute_type get$atribute_name_upper_case() {
        return $atribute_name;
    }
EOT
# Do not indent this line above here!
}

function add_attribute_setter_to_java_file(){
cat  << EOT >> $java_files_output_directory_and_file_name
    
    public void set$atribute_name_upper_case($atribute_type $atribute_name) {
        this.$atribute_name = $atribute_name;
    }
EOT
# Do not indent this line above here!
}

function add_attribute_getter_to_java_file(){
cat  << EOT >> $java_files_output_directory_and_file_name
    
    public $atribute_type get$atribute_name_upper_case() {
        return $atribute_name;
    }
EOT
# Do not indent this line above here!
}

function add_attribute_setter_to_java_file(){

cat  << EOT >> $java_files_output_directory_and_file_name
    
    public void set$atribute_name_upper_case($atribute_type $atribute_name) {
        this.$atribute_name = $atribute_name;
    }
EOT
# Do not indent this line above here!

    
    
}

function add_footer_with_implemented_java_file(){


cat  << EOT >> $java_files_output_directory_and_file_name
    
    @Override
    public boolean isValid() {
        
        // TODO : CODE THIS!
        return true;
    }
    
} // Class generated by : $java_class_generator_name
EOT
# Do not indent this line above here!
}

function create_java_file(){
    add_header_to_java_file
    add_attribute_decleration_to_java_file
    add_getters_and_setters_to_java_file
    add_footer_with_implemented_java_file
}

#add_header_to_java_file