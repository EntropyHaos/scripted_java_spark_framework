function display_file_creation_vars(){
    printf "\nGenerate ftl remove form variables.\n\n"

    printf "create_file_name = %s\n" $create_file_name
    printf "ftl_files_output_directory_and_file_name = %s\n" $ftl_files_output_directory_and_file_name
    printf "index_atribute = %s\n" $index_atribute
    printf "index_atribute_upper_case = %s\n" $index_atribute_upper_case
    printf "entity_to_generate_remove_form_for = %s\n" $entity_to_generate_remove_form_for
    printf "entity_list_suffix_for_json_call = %s\n" $entity_list_suffix_for_json_call
    printf "entity_to_generate_remove_form_for_plural = %s\n" $entity_to_generate_remove_form_for_plural
    printf "entity_to_generate_remove_form_for_lower_case = %s\n" $entity_to_generate_remove_form_for_lower_case
    printf "entity_to_generate_remove_form_for_table_name = %s\n" $entity_to_generate_remove_form_for_table_name

    printf "select_id = %s\n" $select_id
    printf "select_name = %s\n" $select_name
    
    
}

function write_show_entity_ftl_file(){

cat << EOT > $ftl_files_output_directory_and_file_name
 <style>
 table th a {
 	text-transform: capitalize;
 }
 </style>

   <div class="starter-template">
    	<h2> All $entity_to_generate_remove_form_for_plural </h2>
    	<div class="$entity_to_generate_remove_form_for_table_name"> </div>
		<div class="paginationContainer "></div>
    </div>	
 	<script src="js/awesomeTable.js" type="text/javascript"></script>
 	<script>
 		\$( document ).ready(function() {
 			\$.getJSON('/getJson$entity_list_suffix_for_json_call',function(json){
    			if ( json.length == 0 ) {
        			console.log("NO DATA!");
        			\$(".$entity_to_generate_remove_form_for_table_name").text("No $entity_to_generate_remove_form_for_plural Found");
    			}
    			else {
    				var tbl = new awesomeTableJs({
						data:json,
						tableWrapper:".$entity_to_generate_remove_form_for_table_name",
						paginationWrapper:".paginationContainer",
						buildPageSize: false,
						buildSearch: false,
					});
					tbl.createTable();	
    			}
			});
 			
		});
	
	</script>
EOT
}

function set_vars_for_remove_ftl_file(){

    create_file_name="show"$java_class_name".ftl"
    ftl_files_output_directory_and_file_name="$ftl_file_output_directory/$create_file_name"

    for ((attribute_array_index=0;attribute_array_index<${#java_class_attribute_array[@]};attribute_array_index++)); do
        create_attribute_array_split
        if (( $attribute_array_index == 0 ))
        then
            index_atribute=$(printf "%s" $atribute_name)
        fi
    done        
    
    entity_to_generate_remove_form_for=$java_class_name
    entity_list_suffix_for_json_call=$(printf "%sList" $entity_to_generate_remove_form_for)
    entity_to_generate_remove_form_for_plural=$(printf "%ss" $entity_to_generate_remove_form_for)
    entity_to_generate_remove_form_for_lower_case=$entity_to_generate_remove_form_for
    entity_to_generate_remove_form_for_lower_case="$(tr '[:upper:]' '[:lower:]' <<< ${entity_to_generate_remove_form_for_lower_case:0:1})${entity_to_generate_remove_form_for_lower_case:1}"
    
    entity_to_generate_remove_form_for_table_name=$(printf "%sTable" $entity_to_generate_remove_form_for_lower_case)
    
    index_atribute_upper_case=$index_atribute
    index_atribute_upper_case="$(tr '[:lower:]' '[:upper:]' <<< ${index_atribute_upper_case:0:1})${index_atribute_upper_case:1}"
    
    select_id=$(printf "%ss" $entity_to_generate_remove_form_for_lower_case)
    select_name=$(printf "%s%s" $entity_to_generate_remove_form_for_lower_case $index_atribute_upper_case)
}

function create_show_entity_ftl_file(){
    # Make sure there is a directory to put the files in.
    mkdir -p $ftl_file_output_directory
    
    local create_file_name
    local ftl_files_output_directory_and_file_name
    local index_atribute
    local index_atribute_upper_case
    local entity_to_generate_remove_form_for
    local entity_list_suffix_for_json_call
    local entity_to_generate_remove_form_for_plural
    local entity_to_generate_remove_form_for_lower_case
    local entity_to_generate_remove_form_for_table_name
    local select_id
    local select_name

    set_vars_for_remove_ftl_file
    #display_file_creation_vars
    
    write_show_entity_ftl_file
}
