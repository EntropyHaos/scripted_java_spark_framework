function display_file_creation_location_vars(){
    printf "PACKAGE : %s\n" $java_files_output_directory_name
    printf "CREATING FILE : %s\n" $java_files_output_directory_and_file_name
    
}

function add_header_to_ftl_file(){

cat  << EOT > $ftl_files_output_directory_and_file_name
<h2>Enter Details of Exisiting $java_class_name to Update.</h2>
   <p id="status"></p>
  <form action="" method="POST" role="form">
    <div class="form-group">
EOT
# Do not indent this line above here!
}

: << 'EOJ'

      <label for="id">User ID (Less than 8 Characters)</label>
      <input type="text" class="form-control" id="id" name="id" placeholder="Enter User ID to Update">
    </div>
    <div class="form-group">
      <label for="firstName">First Name</label>
      <input type="text" class="form-control" id="firstName" name="firstName" placeholder="Enter First Name">
    </div>
    <div class="form-group">
      <label for="middleName">Middle Name</label>
      <input type="text" class="form-control" id="middleName" name="middleName" placeholder="Enter Middle Name">
    </div>
    <div class="form-group">
      <label for="lastName">Last Name</label>
      <input type="text" class="form-control" id="lastName" name="lastName" placeholder="Enter Last Name">
    </div>
    <div class="form-group">
      <label for="age">Age</label>
      <input type="number" class="form-control" id="age" name="age">
    </div>
    <div class="form-group">
      <label for="phone">Phone Number (Must be of 10 Digits)</label>
      <input type="number" class="form-control" id="phone" name="phone">
    </div>
    <div class="form-group">
      <label for="gender">Gender</label>
      <select class="form-control" id="gender" name="gender">
        <option value="M">M</option>
        <option value="F">F</option>
      </select>
    </div>
    <div class="form-group">
      <label for="zip">Zip Code</label>
      <input type="number" class="form-control" id="zip" name="zip" value=0>
    </div>

EOJ






function add_attribute_set_form_field_to_ftl_file(){

case "$atribute_type" in

    "String" )
    cat  << EOT >> $ftl_files_output_directory_and_file_name

    <div class="form-group">
      <label for="$atribute_name">$atribute_text_for_label</label>
      <input type="text" class="form-control" id="$atribute_name" name="$atribute_name" placeholder="$atribute_text_for_placeholder">
    </div>
EOT
# Do not indent this line above here!
    ;;    

    "int" )
    cat  << EOT >> $ftl_files_output_directory_and_file_name

    <div class="form-group">
      <label for="$atribute_name">$atribute_text_for_label</label>
      <input type="number" class="form-control" id="$atribute_name" name="$atribute_name">
    </div>
EOT
    ;;

    "char" )
    cat  << EOT >> $ftl_files_output_directory_and_file_name

    <div class="form-group">
      <label for="$atribute_name">$atribute_text_for_label</label>
      <select class="form-control" id="$atribute_name" name="$atribute_name">
EOT
#atribute_text_for_placeholder
    char_array=()
    for (( char_index=0 ; char_index < ${#atribute_text_for_placeholder} ; char_index++ )); do 
        char_array[char_index]=${atribute_text_for_placeholder:char_index:1};
        cat  << EOT >> $ftl_files_output_directory_and_file_name
        <option value="${char_array[char_index]}">${char_array[char_index]}</option>
EOT
    done

    cat  << EOT >> $ftl_files_output_directory_and_file_name
      </select>
    </div>
EOT
    ;;
    "long" )
    cat  << EOT >> $ftl_files_output_directory_and_file_name

    <div class="form-group">
      <label for="$atribute_name">$atribute_text_for_label</label>
      <input type="number" class="form-control" id="$atribute_name" name="$atribute_name">
    </div>
EOT
    ;;

    "boolean" )
    
    cat  << EOT >> $ftl_files_output_directory_and_file_name

    <div class="form-group">
		<label for="$atribute_name">$atribute_text_for_label</label><br>
		<input type="radio" name="$atribute_name" value="True"> True
		<input type="radio" name="$atribute_name" value="False" checked> False
    </div>
EOT
    ;;

    "DateTime" )
    
    cat  << EOT >> $ftl_files_output_directory_and_file_name

    <div class="form-group" id="dateInput">
		<label for="$atribute_name">$atribute_text_for_label</label><br>
        <input  type="text" class="form-control" id="$atribute_name" name="$atribute_name" data-provide="datepicker">
    </div>
EOT
    ;;

    * )
    cat  << EOT >> $ftl_files_output_directory_and_file_name

    <div class="form-group">
      <label for="$atribute_name">$atribute_text_for_label</label>
      <input type="text" class="form-control" id="$atribute_name" name="$atribute_name" placeholder="$atribute_text_for_placeholder">
    </div>
EOT
# Do not indent this line above here!
    ;;
    esac
}

function add_footer_to_ftl_file(){
cat  << EOT >> $ftl_files_output_directory_and_file_name
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
            url: "update$java_class_name",
            data: json,
            dataType: "json",
            success : function() {
                \$("#status").text("$java_class_name SuccesFully Updated");
                this_.find('input, select').val('');
            },
            error : function(e) {
                \$("#status").text(e.responseText);
            }
        });
        \$("html, body").animate({ scrollTop: 0 }, "slow");
        return false;
    });
});

</script>
EOT
# Do not indent this line above here!
}





function create_update_entity_ftl_file(){
    # Make sure there is a directory to put the files in.
    mkdir -p $ftl_file_output_directory
    
    local update_file_name="update"$java_class_name"Form.ftl"
    ftl_files_output_directory_and_file_name="$ftl_file_output_directory/$update_file_name"

    add_header_to_ftl_file
    
    for ((attribute_array_index=0;attribute_array_index<${#java_class_attribute_array[@]};attribute_array_index++)); do
        create_attribute_array_split
        add_attribute_set_form_field_to_ftl_file
    done        
    
    add_footer_to_ftl_file

}
