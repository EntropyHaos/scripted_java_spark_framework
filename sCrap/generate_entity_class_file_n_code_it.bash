: << 'EOF'
This file creates an entity class
1st param passed is file name
2nd is className
3rd through second to last are atributes.
4th last is author

Example call:
bash generate_entity_class_file_n_code_it_haos.bash "entityClass.java" testEntityClass one two three four "Ben Haos"

function init(){
    set_vars
}
EOF

source $script_dir/set_location_vars.bash
#java_file_atributes=()

function init(){
    
    set_vars "$@"
    create_package_directory
    add_header_to_java_file
    add_body_to_java_file
    add_footer_to_java_file;
}

function set_vars(){

first_index=1
last_index="${#@}"

package_name=$(printf "%s\n" ${!first_index})
entity_class_type=$(printf "%sEntity\n" $package_name)

package_path_and_name=$(printf "%s%s\n" $apps_entity_package_location $package_name)
file_path_and_name=$(printf "%s/%s.java\n" $package_path_and_name $entity_class_type)
file_author=${!last_index}

for (( i=2; i<=$((${#@}-1)); i++ ))
do
    java_file_atributes[$(($i-2))]=$(printf "%s\n" ${!i})
done

: << 'EOF'
for var in "${java_file_atributes[@]}"
do
    echo $var
done

    #n=1
    #z=${#@}
    #echo ${!z}
    for i in "${@}"
    do
        echo $i
    done

    package_name="$1"
    package_name_and_path="$apps_entity_package_location/$package_name"
    file_name="$1Entity"
    entity_class_type="$2"
    file_author="${!#}"
    atribute_array=${@:3:$(($#-3))}
EOF
}

function create_package_directory(){
    mkdir -p $package_path_and_name
}

function add_header_to_java_file(){
: << 'EOC'
printf "%s\n" $file_path_and_name
EOC

    cat  << EOT > "$file_path_and_name"
package $package_name;
    
public class $entity_class_type{    
    
EOT
# Do not indent this line above here!
}

function add_body_to_java_file(){

    for var in "${java_file_atributes[@]}"
    do
        add_variable_decelerations_to_java_file $var
    done

    for var in "${java_file_atributes[@]}"
    do
        add_getter_and_setter_to_java_file $var
    done
    
    
}

function add_variable_decelerations_to_java_file(){

    string_in="$@"
    declare -a 'arr=('"$string_in"')'   

    cat  << EOT >> "$file_path_and_name"
    ${arr[0]} ${arr[1]} ${arr[2]};
EOT
# Do not indent this line above here!
}

function add_getter_and_setter_to_java_file(){

    string_in="$@"
    declare -a 'arr=('"$string_in"')'   

    var="${arr[2]}"
    var="$(tr '[:lower:]' '[:upper:]' <<< ${var:0:1})${var:1}"
    

    cat  << EOT >>  "$file_path_and_name"

    public ${arr[1]} get$var() {
        return ${arr[2]};
    }
    public void set$var(String ${arr[2]}) {
        this.${arr[2]} = ${arr[2]};
    }
EOT
# Do not indent this line above here!
}

function add_footer_to_java_file(){
    cat  << EOT >> "$file_path_and_name"

} // Entity Class "$entity_class_type" ends. Created by $file_author

EOT
# Do not indent this line above here!
}

init "$@"
