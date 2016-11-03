: << 'EOC'
EOC

script_dir="z_haos"
export script_dir

readarray entitys_atributes < $1

bash $script_dir/make_frameworks_dir_structure.bash

bash $script_dir/generate_entity_class_file_n_code_it.bash "${entitys_atributes[@]}"
bash $script_dir/generate_entity_insert_ftl_template.bash "${entitys_atributes[@]}"



: << 'EOC'

for line in ${entitys_atributes[@]};
do
    echo "$line"
done
getArray() {
    array=() # Create array
    while IFS= read -r line # Read a line
    do
        array+=("$line") # Append line to the array
    done < "$1"
}

getArray "config.txt"
echo "att array length = ${#atribute_array_read[@]}"

    for (( i=0; i<$((${#atribute_array_read[@]})); i++ ));
do
echo ${atribute_array_read[i]}
done
#source $script_set_dir/set_location_vars.bash


#bash $script_dir/make_frameworks_dir_structure.bash
#bash z_haos/generate_entity_class_file_n_code_it.bash
entity_name="User";
atribute_array=('Public' 'String' 'id' 'User Id (Less than 8 Characters)' 'Enter a unique user id');
atribute_array+=('Private' 'String' 'userName' 'First Name' 'Enter a name');
atribute_array+=('Public' 'int' 'num' 'First Name' 'Enter a number');
entity_creator="Benjamin Haos";
EOC




