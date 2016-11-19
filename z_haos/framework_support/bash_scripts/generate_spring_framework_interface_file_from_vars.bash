# echo $scripted_framework_output_root_directory

function display_file_creation_location_vars(){
    printf "PACKAGE : %s\n" $spring_framework_interface_files_directory
}

function generate_spring_interface_file(){

    local lower_case_java_class_name
    lower_case_java_class_name=$(printf "%s" $java_class_name)
    lower_case_java_class_name="$(tr '[:upper:]' '[:lower:]' <<< ${lower_case_java_class_name:0:1})${lower_case_java_class_name:1}"


    local interface_name
    interface_name=$(printf "%sRepository" $java_class_name)
    
    local interface_index_var
    interface_index_var=$(printf "%sNumber" $lower_case_java_class_name)
    
    local interface_index_var_upper_case
    interface_index_var_upper_case=$(printf "%sNumber" $java_class_name)
    
    local delete_string=$(printf "%sBy%s" $java_class_name $interface_index_var_upper_case)
    
    cat  << EOT > $spring_framework_interface_file_directory_and_name_one
    
package repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

import entities.$java_class_name;

public interface $interface_name extends MongoRepository<$java_class_name, String> {

	List<$java_class_name> findBy$interface_index_var_upper_case(@Param("$interface_index_var") String $interface_index_var);
	// Sauce : http://stackoverflow.com/questions/17484153/how-to-delete-items-in-mongorepository-using-query-annotation
	Long delete$delete_string(String $interface_index_var);
	// Sauce : http://stackoverflow.com/questions/16715010/count-in-spring-data-mongodb-repository
	Long countBy$interface_index_var_upper_case(String $interface_index_var);
	// Sauce : this just seems reasonable?
	List<$java_class_name> findAll();
}    
EOT


}

function spring_framework_interface_file(){
    #display_file_creation_location_vars
    
    mkdir -p $spring_framework_interface_files_directory
    
    spring_framework_interface_file_name=$(printf "%sRepository.java" $java_class_name)
    
    spring_framework_interface_file_directory_and_name_one="$spring_framework_interface_files_directory/$spring_framework_interface_file_name"

    generate_spring_interface_file;
}
