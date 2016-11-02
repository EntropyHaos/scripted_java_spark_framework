: << 'EOF'
This file creates an entity insert ftl file

In Progress

EOF

function init(){
    
    #say_hello

    set_vars "$@"
    
    #display_vars

    create_header
    create_body_from_array
    #create_body
    #create_footer
}

function say_hello(){
    echo Hello!
}

function display_vars(){
    : << 'EOC'
    echo "$file_name"
    echo "$file_header_text"
    echo "$file_url"
    echo "$file_author"
EOC

    : << 'EOC'
EOC
    for var in $atribute_array
    do
    echo "$var"
done

    
}
function create_header(){
    cat  << EOT > $file_name
    
<h2>$file_header_text</h2>
    <p id="status"></p>
    <form action="" method="POST" role="form">
    
EOT
# Do not indent this line above here!
}

function create_body(){
    for var in $atribute_array
    do
        create_variable_decelerations "$var"
    done
    
}

function create_body_from_array(){
    for var in $atribute_array
    do
        echo $var
        #create_variable_decelerations "$var"
    done
    
}

function create_variable_decelerations(){
    cat  << EOT >> "$file_name"

    <div class="form-group">
        <label for="$1">Enter atribute : $1</label>
        <input type="text" class="form-control" id="$1" name="$1" placeholder="Enter Unique ID Less Than 8 Characters">
    </div>

EOT
# Do not indent this line above here!
}

function create_footer(){
#echo $file_name
    cat  << EOT >> "$file_name"

</form>


<!-- Simple JS Function to convert the data into JSON and Pass it as ajax Call --!>
<script>
\$(function() {
    \$('form').submit(function(e) {
        e.preventDefault();
        var this_ = $(this);
        var array = this_.serializeArray();
        var json = {};
    
        \$.each(array, function() {
            json[this.name] = this.value || '';
        });
        json = JSON.stringify(json);
    
        // Ajax Call
        \$.ajax({
            type: "POST",
            url: "$file_url",
            data: json,
            dataType: "json",
            success : function() {
                \$("#status").text("User SuccesFully Added");
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

<!-- Template file "$file_name" ends here. Created by : $file_author -->

EOT
# Do not indent this line above here!




}

function set_vars(){
    file_name="$1"
    file_header_text="Create $2"
    file_url="create$2"
    file_author="${!#}"
    atribute_array="${@:3:$(($#-3))}"
}

init "$@"

