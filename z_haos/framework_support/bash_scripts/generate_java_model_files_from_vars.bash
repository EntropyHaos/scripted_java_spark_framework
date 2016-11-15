# echo $scripted_framework_output_root_directory

function display_file_creation_location_vars(){
    printf "PACKAGE : %s\n" $java_class_model_files_directory
    printf "CREATING FILE ONE : %s\n" $java_class_model_files_directory_and_name_one
    printf "CREATING FILE TWO : %s\n" $java_class_model_files_directory_and_name_two
}

function add_header_to_java_model_file_one(){
    model_class_name=$(printf "%sModel" $java_class_name)
    cat  << EOT > $java_class_model_files_directory_and_name_one
package models;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.joda.time.*;

public class $model_class_name {
    private Map<String, Object> $java_class_name_lower_case;

    /**
     * Constructor
     */
    public $model_class_name() {
        this.$java_class_name_lower_case = new HashMap<>();
    }
EOT
# Do not indent this line above here!
}

function add_create_function_to_model_file_one(){
    
    param_string="("        
    table_type="$java_class_name"Table
    table_name="usr"
    
    index_array=""
    index_array_upper_case=""
    for ((attribute_array_index=0;attribute_array_index<${#java_class_attribute_array[@]};attribute_array_index++)); do
        create_attribute_array_split
        if (( $attribute_array_index == 0 ))
        then
            index_array=$atribute_name
            index_array_upper_case=$index_array
            index_array_upper_case="$(tr '[:lower:]' '[:upper:]' <<< ${index_array_upper_case:0:1})${index_array_upper_case:1}"
        fi
        param_string="$param_string$atribute_type $atribute_name"
        if (("$attribute_array_index" < "$((${#java_class_attribute_array[@]}-1))")); then
            param_string="$param_string, "
        else
            param_string="$param_string)"
        fi
    done


    cat  << EOT >> $java_class_model_files_directory_and_name_one
    
    public int create$java_class_name$param_string{
        
        $table_type $table_name = new $table_type();

EOT
    

    for ((attribute_array_index=0;attribute_array_index<${#java_class_attribute_array[@]};attribute_array_index++)); do
        create_attribute_array_split
        cat  << EOT >> $java_class_model_files_directory_and_name_one
        $table_name.set$atribute_name_upper_case($atribute_name);
EOT
    done

    cat  << EOT >> $java_class_model_files_directory_and_name_one
        $java_class_name_lower_case.put($index_array, $table_name);
EOT

    cat  << EOT >> $java_class_model_files_directory_and_name_one
    
        return 1;
    }
EOT
}

function add_check_function_to_model_file_one(){
    
    table_type="$java_class_name"Table

    cat  << EOT >> $java_class_model_files_directory_and_name_one
    
    /**
     * Check to find if a user is available
     * @param id
     * @return
     */
    public boolean check$java_class_name(String id) {
        Iterator it = $java_class_name_lower_case.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry pair = (Map.Entry)it.next();
            $table_type u = ($table_type)pair.getValue();
            if((u.get$index_array_upper_case().equals(id)))
                return false;
        }
        return true;
    }
EOT
    
}

function add_remove_user_function_to_model_file_one(){
    
    table_type="$java_class_name"Table

    cat  << EOT >> $java_class_model_files_directory_and_name_one
    
    public boolean remove$java_class_name(String id) {
        if(!check$java_class_name(id)) {
            $java_class_name_lower_case.remove(id);
            return true;    
        }
        return false;
    }
EOT
    
}

function add_update_function_to_model_file_one(){
    
    table_type="$java_class_name"Table
    table_name="usr"

    param_string="("        

    for ((attribute_array_index=0;attribute_array_index<${#java_class_attribute_array[@]};attribute_array_index++)); do
        create_attribute_array_split
        param_string="$param_string$atribute_type $atribute_name"
        if (("$attribute_array_index" < "$((${#java_class_attribute_array[@]}-1))")); then
            param_string="$param_string, "
        else
            param_string="$param_string)"
        fi
    done

    cat  << EOT >> $java_class_model_files_directory_and_name_one
    
    public int update$java_class_name$param_string{
EOT
    attribute_array_index=0
    create_attribute_array_split
        
    cat  << EOT >> $java_class_model_files_directory_and_name_one

        $table_type $table_name = ($table_type)$java_class_name_lower_case.get($atribute_name);

EOT
# Do not indent this line above here!
    
    for ((attribute_array_index=1;attribute_array_index<${#java_class_attribute_array[@]};attribute_array_index++)); do
        create_attribute_array_split
        cat  << EOT >> $java_class_model_files_directory_and_name_one
        $table_name.set$atribute_name_upper_case($atribute_name);
EOT
# Do not indent this line above here!
    done

    cat  << EOT >> $java_class_model_files_directory_and_name_one
        $java_class_name_lower_case.put($index_array, $table_name);
    
        return 1;
    }
EOT
# Do not indent this line above here!
}

function add_list_return_functions_to_model_file_one(){
    send_var="send$java_class_name"sId
    cat  << EOT >> $java_class_model_files_directory_and_name_one
    public List sendElements() {
        List<Object> ret = new ArrayList<>($java_class_name_lower_case.values());
        return ret;
    }

    public List $send_var() {
        List<Object> ret = new ArrayList<>($java_class_name_lower_case.keySet());
        return ret;
    }

EOT
# Do not indent this line above here!
}

function add_footer_to_model_file_one(){
cat  << EOT >> $java_class_model_files_directory_and_name_one
} // Class generated by : $java_class_generator_name
EOT
# Do not indent this line above here!
}


function add_header_to_model_file_two(){

table_type="$java_class_name"Table

    cat  << EOT > $java_class_model_files_directory_and_name_two
package models;

import org.joda.time.*;
    
public class $table_type{    
    
EOT
# Do not indent this line above here!
}

function add_attribute_declerations_to_model_file_two(){

    for ((attribute_array_index=0;attribute_array_index<${#java_class_attribute_array[@]};attribute_array_index++)); do
        create_attribute_array_split
        cat  << EOT >> $java_class_model_files_directory_and_name_two
    $atribute_protection_var $atribute_type $atribute_name;
EOT
# Do not indent this line above here!
    done        
}

function add_getters_and_setters_to_model_file_two(){
    for ((attribute_array_index=0;attribute_array_index<${#java_class_attribute_array[@]};attribute_array_index++)); do
        create_attribute_array_split
        add_attribute_getter_to_model_file_two
        add_attribute_setter_to_model_file_two
    done        
}

function add_attribute_getter_to_model_file_two(){
cat  << EOT >> $java_class_model_files_directory_and_name_two
    
    public $atribute_type get$atribute_name_upper_case() {
        return $atribute_name;
    }
EOT
# Do not indent this line above here!
}

function add_attribute_setter_to_model_file_two(){
cat  << EOT >> $java_class_model_files_directory_and_name_two
    
    public void set$atribute_name_upper_case($atribute_type $atribute_name) {
        this.$atribute_name = $atribute_name;
    }
EOT
# Do not indent this line above here!
}

function add_footer_to_model_file_two(){
cat  << EOT >> $java_class_model_files_directory_and_name_two
    
} // Class generated by : $java_class_generator_name
EOT
# Do not indent this line above here!
}

function generate_file_one(){
    add_header_to_java_model_file_one
    add_create_function_to_model_file_one
    add_check_function_to_model_file_one
    add_update_function_to_model_file_one
    add_remove_user_function_to_model_file_one
    add_list_return_functions_to_model_file_one
    add_footer_to_model_file_one
}

function generate_file_two(){
    add_header_to_model_file_two
    add_attribute_declerations_to_model_file_two
    add_getters_and_setters_to_model_file_two
    add_footer_to_model_file_two
}

function create_java_model_files(){
    #display_file_creation_location_vars
    
    mkdir -p $java_class_model_files_directory

    model_file_name=$(printf "%sModel.java" $java_class_name)
    table_file_name=$(printf "%sTable.java" $java_class_name)
    java_class_model_files_directory_and_name_one="$java_class_model_files_directory/$model_file_name"
    java_class_model_files_directory_and_name_two="$java_class_model_files_directory/$table_file_name"

    generate_file_one
    generate_file_two
}

