#!/bin/bash
# Help from : http://stackoverflow.com/questions/17232526/how-to-pass-an-array-argument-to-the-bash-script

console_display_entity_name_and_file=false
console_display_entity_atributes_and_its_values=false
console_display_entity_creators_name=false

function init(){
    set_vars "$@"
    add_header_to_ftl_file;
    add_input_fields_to_form;
    add_footer_to_file_with_authors_name;
}

function set_vars(){
    
    var_array=()
    num_params=${#@}
    
    line_array=()
    array_count=0
    for var in "$@"
    do
        line_array[$array_count]=$var
        let array_count=$array_count+1;
    done
    
    atribute_array=()
    
    entity_name=${line_array[0]}
    
# Define the file to write to.    

    file_name=${line_array[0]}
    file_extension=".ftl"
    file_name="$(printf "%s" $file_name)"
    file_name="create$file_name$file_extension"
    
# Set the Author Variable.    
    let last_element_index=$array_count-1
    file_author=${line_array[last_element_index]}

# Seperate out the atributes to add to the file.
    for (( i=1; i<last_element_index; i++ ))
    do
        atribute_array[i-1]=${line_array[i]}
    done
    
    let num_of_atributes=${#atribute_array[@]}
}


function add_header_to_ftl_file(){
    #echo "HEADER FOR : $file_name"
    cat  << EOT > $file_name
    
<h2>Create a $entity_name</h2>
    <p id="status"></p>
    <form action="" method="POST" role="form">
    
EOT
# Do not indent this line above here!
}

function add_input_fields_to_form(){
    
    for (( i=0; i<${#atribute_array[@]};i++ ));
    do

        declare -a 'arr=('"${atribute_array[i]}"')'
        #printf "%s\n" "${arr[@]}"
        add_entity_atribute_form_field_to_ftl_file "${arr[@]}"
    done
    
    
    : << 'eof'
    for ((i=0; i<${#atribute_array[*]}; i+=5));
    do
        atribute_access_level_modifier="${atribute_and_specs_for_atributes_array[i]}"
        atribute_type="${atribute_and_specs_for_atributes_array[i+1]}"
        atribute_name="${atribute_and_specs_for_atributes_array[i+2]}"
        atribute_label="${atribute_and_specs_for_atributes_array[i+3]}"
        atribute_message="${atribute_and_specs_for_atributes_array[i+4]}"

        add_entity_atribute_form_field_to_ftl_file "$atribute_label" "$atribute_name" "$atribute_type" "$atribute_message"
    done
eof
}

function add_entity_atribute_form_field_to_ftl_file(){
        
        temp=()
        count=0
        for var in "$@"
        do
        temp[$count]=$var
        let count=$count+1
        done
        
        #echo "${temp[@]}"
        
        type_of_atribute_field_will_accept="${temp[1]}"
        name_of_atribute_associated_with_field="${temp[2]}"
        label_to_use="${temp[3]}";
        message_displayed_in_field_when_empty="${temp[4]}"
        
    #if $console_display_entity_atributes_and_its_values; then printf "\n%s\n" "Entity atributes are:"; display_atribute_specs; fi

    cat  << EOT >> $file_name

    <div class="form-group">
      <label for="$name_of_atribute_associated_with_field">$label_to_use</label>
      <input type="text" class="form-control" id="$name_of_atribute_associated_with_field" name="$name_of_atribute_associated_with_field" placeholder="$message_displayed_in_field_when_empty">
    </div>

EOT
        : << 'eof'
eof
}

function add_footer_to_file_with_authors_name(){
    #echo "FOOTER FOR : $file_name"
    
    cat  << EOT >> $file_name

    <button type="submit" class="btn btn-default">Submit</button>
  </form>

<!-- Simple JS Function to convert the data into JSON and Pass it as ajax Call --!>
<script>
\$(function() {
    \$('form').submit(function(e) {
        e.preventDefault();
        var this_ = \$(this);
        var array = this_.serializeArray();
        var json = {};
    
        \$.each(array, function() {
            json[this.name] = this.value || '';
        });
        json = JSON.stringify(json);
    
        // Ajax Call
        \$.ajax({
            type: "POST",
            url: "create$entity_name",
            data: json,
            dataType: "json",
            success : function() {
                \$("#status").text("$entity_name SuccesFully Added");
                this_.find('input,select').val('');
            },
            error : function(e) {
                console.log(e.responseText);
                \$("#status").text(e.responseText);
            }
        });
        \$("html, body").animate({ scrollTop: 0 }, "slow");
        return false;
    });
});

</script>

<!-- End of ftl file Creator : $file_author -->
EOT

    #if $console_display_entity_creators_name; then display_entity_creator; fi
    
}

function display_entity_being_worked_with_and_file_being(){
    printf "\n%s\n" "File written : $file_name"
    printf "\n%s\n" "Entity name is : $entity_name"
}
function display_entity_creator(){
    printf "\n%s\n" "File author : $file_author"
}
function display_atribute_specs(){
        printf "%s\n" " Name : $name_of_atribute_associated_with_field"
        printf "%s\n" " Type : $type_of_atribute_field_will_accept"
        printf "%s\n" " Label above field : $label_to_use"
        printf "%s\n" " Field input default message : $message_displayed_in_field_when_empty"
}

param=()
for i; do 
#echo $i
params+=("$i")
done

init "${params[@]}"