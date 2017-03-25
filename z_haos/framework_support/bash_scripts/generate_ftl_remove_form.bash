function display_file_creation_vars(){
    printf "\nGenerate ftl remove form variables.\n\n"

    printf "create_file_name = %s\n" $create_file_name
    printf "ftl_files_output_directory_and_file_name = %s\n" $ftl_files_output_directory_and_file_name
    printf "index_atribute = %s\n" $index_atribute
    printf "index_atribute_upper_case = %s\n" $index_atribute_upper_case
    printf "entity_to_generate_remove_form_for = %s\n" $entity_to_generate_remove_form_for
    printf "entity_to_generate_remove_form_for_lower_case = %s\n" $entity_to_generate_remove_form_for_lower_case
    printf "entity_to_generate_remove_form_for_lower_case_plural = %s\n" $entity_to_generate_remove_form_for_lower_case_plural

    printf "select_id = %s\n" $select_id
    printf "select_name = %s\n" $select_name
    
    
}

function write_remove_ftl_file(){

cat << EOT > $ftl_files_output_directory_and_file_name
<div class="starter-template">
	<h2> Remove $java_class_name </h2>
    	<p id="status"></p>
  	<div class="form-group">
      		<label for="id">Select $entity_to_generate_remove_form_for.$index_atribute to Remove</label>
      		<select id="$select_id" name="$select_name"></select>
    	</div>
      <button type="submit" class="btn btn-default">Submit</button>
      <p id="status"></p>
</div>	

<script>
\$( document ).ready(function() {
      var $entity_to_generate_remove_form_for_lower_case = \${$select_id};
      var sel = \$('#$entity_to_generate_remove_form_for_lower_case_plural');
      \$.each($entity_to_generate_remove_form_for_lower_case, function(key,val){
        sel.append('<option value="' + val + '">' + val + '</option>');   
      });
      \$("button").on("click", function(e) {
      	e.preventDefault();
        var this_ = \$(this);
        var arr = \$("#$select_id").val();
        // Ajax Call
        \$.ajax({
            type: "PUT",
            url: 'remove$entity_to_generate_remove_form_for/' + arr,
            success : function(e) {
                \$("#$select_id option:selected").remove();
                \$("#status").text(e);
            },
            error : function(e) {
                \$("#status").text(e);
            }
        });
        return false;
    });
});
	
</script>
EOT
}

function set_vars_for_remove_ftl_file(){

    create_file_name="remove"$java_class_name"Form.ftl"
    ftl_files_output_directory_and_file_name="$ftl_file_output_directory/$create_file_name"

    for ((attribute_array_index=0;attribute_array_index<${#java_class_attribute_array[@]};attribute_array_index++)); do
        create_attribute_array_split
        if (( $attribute_array_index == 0 ))
        then
            index_atribute=$(printf "%s" $atribute_name)
        fi
    done        
    
    entity_to_generate_remove_form_for=$java_class_name

    entity_to_generate_remove_form_for_lower_case=$entity_to_generate_remove_form_for
    entity_to_generate_remove_form_for_lower_case="$(tr '[:upper:]' '[:lower:]' <<< ${entity_to_generate_remove_form_for_lower_case:0:1})${entity_to_generate_remove_form_for_lower_case:1}"
    entity_to_generate_remove_form_for_lower_case_plural=$(printf "%ss" $entity_to_generate_remove_form_for_lower_case)
    index_atribute_upper_case=$index_atribute
    index_atribute_upper_case="$(tr '[:lower:]' '[:upper:]' <<< ${index_atribute_upper_case:0:1})${index_atribute_upper_case:1}"
    
    select_id=$(printf "%ss" $entity_to_generate_remove_form_for_lower_case)
    select_name=$(printf "%s%s" $entity_to_generate_remove_form_for_lower_case $index_atribute_upper_case)
}

function create_remove_ftl_file(){
    # Make sure there is a directory to put the files in.
    mkdir -p $ftl_file_output_directory
    
    local create_file_name
    local ftl_files_output_directory_and_file_name
    local index_atribute
    local index_atribute_upper_case
    local entity_to_generate_remove_form_for
    local entity_to_generate_remove_form_for_lower_case
    local entity_to_generate_remove_form_for_lower_case_plural
    local select_id
    local select_name

    set_vars_for_remove_ftl_file

    #display_file_creation_vars
    
    write_remove_ftl_file
}
