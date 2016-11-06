# echo $scripted_framework_output_root_directory

function display_file_creation_location_vars(){
    #printf "PACKAGE : %s\n" $java_files_output_directory_name
    printf "CREATING FILE : %s\n" $java_driver_files_location_and_name
    
    printf "Driver to be configurated For %s entities:\n\n" ${#driver_config_entities[@]}
    
    for entity_var in ${driver_config_entities[@]}
    do
        printf ">%s<\n" $entity_var
    done
    
    printf "\n" ${#driver_config_entities[@]}
}

function add_header_to_java_file(){

mkdir -p $java_driver_files_location

: << 'EOC'
EOC
insert_var_1=User
insert_var_2=userMod
insert_var3=UserModel
insert_var4=Users
insert_var5=UserList
insert_var6=UsersId
insert_var7=users


cat  << EOT > $java_driver_files_location_and_name
package Driver;

import Model.$insert_var3;
import TemplateEngine.FreeMarkerEngine;
import $insert_var_1.$insert_var_1;
import java.io.IOException;
import static spark.Spark.*;
import spark.ModelAndView;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.Map;

public class MainClass {
    
    public static void main(String[] args) {
        staticFileLocation("/public");
        MainClass s = new MainClass();
        
        port(8080); // Spark will run on port 8080
        
        s.init();
    }
    
    /**
     *  Function for Routes
     */
    private void init() {
    	$insert_var3 $insert_var_2 = new $insert_var3();
        
    	$insert_var_2.create$insert_var_1("benHaos", "Ben", "Jon", "Haos", 43, 'M', "4142021234", 12345);
    	$insert_var_2.create$insert_var_1("entHaos", "Joe", "Jack", "Henry", 18, 'M', "1234567890", 54321);
        
        get("/", (request, response) -> {
           Map<String, Object> viewObjects = new HashMap<String, Object>();
           viewObjects.put("title", "Welcome to Spark Project");
           viewObjects.put("templateName", "home.ftl");
           return new ModelAndView(viewObjects, "main.ftl");
        }, new FreeMarkerEngine());
        
        get("/create$insert_var_1", (request, response) -> {
           Map<String, Object> viewObjects = new HashMap<String, Object>();
           viewObjects.put("templateName", "createForm.ftl");
           return new ModelAndView(viewObjects, "main.ftl");
        }, new FreeMarkerEngine());
        
        post("/create$insert_var_1", (request, response) -> {
            ObjectMapper mapper = new ObjectMapper();
            try {
                $insert_var_1 u = mapper.readValue(request.body(), $insert_var_1.class);
                if (!u.isValid()) {
                    response.status(400);
                    return "Correct the fields";
                }
                if($insert_var_2.check$insert_var_1(u.getId())) {
                    int id = $insert_var_2.create$insert_var_1(u.getId(), u.getFirstName(), u.getMiddleName(), u.getLastName(),
                    u.getAge(), u.getGender(), u.getPhone(), u.getZip());
                    response.status(200);
                    response.type("application/json");
                    return id;
                }
                else {
                    response.status(400);
                    response.type("application/json");
                    return "$insert_var_1 Already Exists";
                }
                } catch (JsonParseException jpe) {
                    response.status(404);
                    return "Exception";
                }
        });
        
        get("/getAll$insert_var4", (request, response) -> {
            response.status(200);
            Map<String, Object> viewObjects = new HashMap<String, Object>();
            viewObjects.put("templateName", "show$insert_var_1.ftl");
            return new ModelAndView(viewObjects, "main.ftl");
        }, new FreeMarkerEngine());

        get("/getJson$insert_var5", (request, response) -> {
            response.status(200);
            return toJSON($insert_var_2.sendElements());
        });

        get("/remove$insert_var_1", (request, response) -> {
           Map<String, Object> viewObjects = new HashMap<String, Object>();
           viewObjects.put("templateName", "remove$insert_var_1.ftl"); 
           viewObjects.put("$insert_var7", toJSON($insert_var_2.send$insert_var6()));
           return new ModelAndView(viewObjects, "main.ftl");
        }, new FreeMarkerEngine());

        put("/remove$insert_var_1/:id", (request, response) -> {
            String id = request.params(":id");
            Map<String, Object> viewObjects = new HashMap<String, Object>();
            if($insert_var_2.remove$insert_var_1(id)) return "$insert_var_1 Removed";
            else return "No Such $insert_var_1 Found";
        });
        
        get("/update$insert_var_1", (request, response) -> {
           Map<String, Object> viewObjects = new HashMap<String, Object>();
           viewObjects.put("templateName", "updateForm.ftl");
           return new ModelAndView(viewObjects, "main.ftl");
        }, new FreeMarkerEngine());
        
        post("/update$insert_var_1", (request, response) -> {
            ObjectMapper mapper = new ObjectMapper();
            
            try {
                $insert_var_1 u = mapper.readValue(request.body(), $insert_var_1.class);
                if (!u.isValid()) {
                    response.status(400);
                    return "Correct the fields";
                }
                if(!$insert_var_2.check$insert_var_1(u.getId())) {
                    int id = $insert_var_2.update$insert_var_1(u.getId(), u.getFirstName(), u.getMiddleName(), u.getLastName(),
                    u.getAge(), u.getGender(), u.getPhone(), u.getZip());
                    response.status(200);
                    response.type("application/json");
                    return id;
                }
                else {
                    response.status(404);
                    return "$insert_var_1 Does Not Exists";
                }
                } catch (JsonParseException jpe) {
                    response.status(404);
                    return "Exception";
                }
        });
        
    }
    
    /**
     *  This function converts an Object to JSON String
     * @param obj
     */
    private static String toJSON(Object obj) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            mapper.enable(SerializationFeature.INDENT_OUTPUT);
            StringWriter sw = new StringWriter();
            mapper.writeValue(sw, obj);
            return sw.toString();
        }
        catch(IOException e) {
            System.err.println(e);
        }
        return null;
    }
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
    display_file_creation_location_vars
    add_header_to_java_file
    #add_attribute_decleration_to_java_file
    #add_getters_and_setters_to_java_file
    #add_footer_with_implemented_java_file
}

#add_header_to_java_file


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