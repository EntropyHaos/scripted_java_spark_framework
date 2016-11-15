# echo $scripted_framework_output_root_directory

function display_file_creation_location_vars(){
    #printf "PACKAGE : %s\n" $java_files_output_directory_name
    printf "CREATING FILE : %s\n" $java_driver_files_location_and_name
    
: << 'EOJ'

    printf "Driver to be configurated For %s entities:\n\n" ${#driver_config_entities[@]}
    
    for entity_var in ${driver_config_entities[@]}
    do
        printf ">%s<\n" $entity_var
    done
    
    printf "\n" ${#driver_config_entities[@]}
EOJ
}

function add_header_to_java_main_file(){

mkdir -p $java_driver_files_location

cat  << EOT > $java_driver_files_location_and_name
package drivers;

import templateEngine.FreeMarkerEngine;
import java.io.IOException;
import static spark.Spark.*;
import spark.ModelAndView;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.Map;



import models.*;
import entities.*;
import controls.*;

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

EOT
}

function set_vars_for_entity_to_add(){

    entity_var_lower_case=$(printf "%s" $entity_var)
    
    entity_var_lower_case="$(tr '[:upper:]' '[:lower:]' <<< ${entity_var_lower_case:0:1})${entity_var_lower_case:1}"
    
    insert_var_1=$entity_var
    insert_var_2=$(printf "%sMod" $entity_var_lower_case)
    insert_var_3=$(printf "%sModel" $entity_var)
    insert_var_4=$(printf "%ss" $entity_var)
    insert_var_5=$(printf "%sList" $entity_var)
    insert_var_6=$(printf "%ssId" $entity_var)
    insert_var_7=$(printf "%ss" $entity_var_lower_case)
    insert_var_8=$(printf "%sForm" $entity_var)

    for ((attribute_array_index=0;attribute_array_index<${#java_class_attribute_array[@]};attribute_array_index++)); do
        create_attribute_array_split

        temp_insert_var=""
        temp_insert_var=$atribute_name
        temp_insert_var="$(tr '[:lower:]' '[:upper:]' <<< ${temp_insert_var:0:1})${temp_insert_var:1}"
        if (( $attribute_array_index == 0 ))
        then
            param_insert="("
        fi
        if (("$attribute_array_index" < "$((${#java_class_attribute_array[@]}-1))")); then
            param_insert=$(printf "%su.get%s(), " "$param_insert" "$temp_insert_var")
        else
            param_insert=$(printf "%su.get%s())" "$param_insert" "$temp_insert_var")
        fi
        index_array=""
        index_array_upper_case=""

        if (( $attribute_array_index == 0 ))
        then
            index_param=$atribute_name
            index_param_upper_case=$index_param
            index_param_upper_case="$(tr '[:lower:]' '[:upper:]' <<< ${index_param_upper_case:0:1})${index_param_upper_case:1}"
        fi
    done
    
}

function display_vars_for_entity_to_add(){
    
    printf "\nINSERT VARS FOR : '%s'\n\n" $entity_var
    printf "insert_var_1 = %s\n" $insert_var_1
    printf "insert_var_2 = %s\n" $insert_var_2
    printf "insert_var_3 = %s\n" $insert_var_3
    printf "insert_var_4 = %s\n" $insert_var_4
    printf "insert_var_5 = %s\n" $insert_var_5
    printf "insert_var_6 = %s\n" $insert_var_6
    printf "insert_var_7 = %s\n" $insert_var_7
    printf "insert_var_8 = %s\n" $insert_var_8
    printf "\n"
    
}

function add_model_decleration(){
    local entity_var
    entity_var=$java_class_name
    
    set_vars_for_entity_to_add    
    #display_vars_for_entity_to_add
    cat  << EOT >> $java_driver_files_location_and_name
    	$insert_var_3 $insert_var_2 = new $insert_var_3();
EOT
}

function add_mongo_db_controller_decleration(){

    cat  << EOT >> $java_driver_files_location_and_name
    	ChocoMongoController mongoController = new ChocoMongoController("ChocoMongoDB");
EOT
}

function add_root_route(){
cat  << EOT >> $java_driver_files_location_and_name

        get("/", (request, response) -> {
           Map<String, Object> viewObjects = new HashMap<String, Object>();
           viewObjects.put("title", "Welcome to Spark Project");
           viewObjects.put("templateName", "home.ftl");
           return new ModelAndView(viewObjects, "main.ftl");
        }, new FreeMarkerEngine());

EOT

}

function add_get_and_post_to_java_main_file(){
    local entity_var
    entity_var=$java_class_name
    
    set_vars_for_entity_to_add    
    display_vars_for_entity_to_add
    
    cat  << EOT >> $java_driver_files_location_and_name
        get("/create$insert_var_1", (request, response) -> {
           Map<String, Object> viewObjects = new HashMap<String, Object>();
           viewObjects.put("templateName", "create$insert_var_8.ftl");
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
                if($insert_var_2.check$insert_var_1(u.get$index_param_upper_case())) {
                    response.status(200);
                    response.type("application/json");
                    mongoController.add_new_record(u);
                    return 1;
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
        
        get("/getAll$insert_var_4", (request, response) -> {
            response.status(200);
            Map<String, Object> viewObjects = new HashMap<String, Object>();
            viewObjects.put("templateName", "show$insert_var_1.ftl");
            return new ModelAndView(viewObjects, "main.ftl");
        }, new FreeMarkerEngine());

        get("/getJson$insert_var_5", (request, response) -> {
            response.status(200);
            return mongoController.getCollectionListJSON("$insert_var_1");
        });

        get("/remove$insert_var_1", (request, response) -> {
           Map<String, Object> viewObjects = new HashMap<String, Object>();
           viewObjects.put("templateName", "remove$insert_var_8.ftl");
           viewObjects.put("$insert_var_7", mongoController.getListOfCollectionsIDs("$insert_var_1"));
           return new ModelAndView(viewObjects, "main.ftl");
        }, new FreeMarkerEngine());

        put("/remove$insert_var_1/:id", (request, response) -> {
            String id = request.params(":id");
            Map<String, Object> viewObjects = new HashMap<String, Object>();
            if(mongoController.removeFromCollectionDocumentByID("$insert_var_1", id)) return "$insert_var_1 Removed";
            else return "No Such $insert_var_1 Found";
            
        });
        
        get("/update$insert_var_1", (request, response) -> {
           Map<String, Object> viewObjects = new HashMap<String, Object>();
           viewObjects.put("templateName", "update$insert_var_8.ftl");
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
                if(!$insert_var_2.check$insert_var_1(u.get$index_param_upper_case())) {
                    response.status(200);
                    response.type("application/json");
                    return 1;
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
        
EOT
}

function add_footer_to_java_main_file(){
    cat  << EOT >> $java_driver_files_location_and_name
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
}




function create_java_file(){
    #display_file_creation_location_vars
    local entity_var
    entity_var=$java_class_name
    #add_header_to_java_file
    #add_attribute_decleration_to_java_file
    #add_getters_and_setters_to_java_file
    #add_footer_with_implemented_java_file
}

: << 'EOJ'
#add_header_to_java_file
function add_header_to_java_file(){

mkdir -p $java_driver_files_location

: << 'EOC'
EOC

    #java_class_name_lower_case=$(printf "%s" ${class_configs_lines[1]})
    #java_class_name_lower_case="$(tr '[:upper:]' '[:lower:]' <<< ${java_class_name_lower_case:0:1})${java_class_name_lower_case:1}"


entity_var_lower_case=$(printf "%s" $entity_var)


entity_var_lower_case="$(tr '[:upper:]' '[:lower:]' <<< ${entity_var_lower_case:0:1})${entity_var_lower_case:1}"


insert_var_1=$entity_var
insert_var_2=$(printf "%sMod" $entity_var_lower_case)
insert_var_3=$(printf "%sModel" $entity_var)
insert_var_4=$(printf "%ss" $entity_var)
insert_var_5=$(printf "%sList" $entity_var)
insert_var_6=$(printf "%ssId" $entity_var)
insert_var_7=$(printf "%ss" $entity_var_lower_case)
insert_var_8=$(printf "%sForm" $entity_var)

: << 'EOD'

echo $insert_var_1
echo $insert_var_2
echo $insert_var_3
echo $insert_var_4
echo $insert_var_5
echo $insert_var_6
echo $insert_var_7
echo $insert_var_8
EOD

    for ((attribute_array_index=0;attribute_array_index<${#java_class_attribute_array[@]};attribute_array_index++)); do
        create_attribute_array_split
#        cat  << EOT >> $java_class_model_files_directory_and_name_one
#EOT
        #echo $atribute_name
        
        temp_insert_var=""
        temp_insert_var=$atribute_name
        temp_insert_var="$(tr '[:lower:]' '[:upper:]' <<< ${temp_insert_var:0:1})${temp_insert_var:1}"
        if (( $attribute_array_index == 0 ))
        then
            param_insert="("
        fi
        if (("$attribute_array_index" < "$((${#java_class_attribute_array[@]}-1))")); then
            param_insert=$(printf "%su.get%s(), " "$param_insert" "$temp_insert_var")
        else
            param_insert=$(printf "%su.get%s())" "$param_insert" "$temp_insert_var")
        fi
        index_array=""
        index_array_upper_case=""

        if (( $attribute_array_index == 0 ))
        then
            index_param=$atribute_name
            index_param_upper_case=$index_param
            index_param_upper_case="$(tr '[:lower:]' '[:upper:]' <<< ${index_param_upper_case:0:1})${index_param_upper_case:1}"
        fi
    done

    #echo $param_insert
    #echo $index_param_upper_case

cat  << EOT > $java_driver_files_location_and_name
package drivers;

import templateEngine.FreeMarkerEngine;
import java.io.IOException;
import static spark.Spark.*;
import spark.ModelAndView;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.Map;

import models.$insert_var_3;
import entities.$insert_var_1;

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
        
    	//$insert_var_2.create$insert_var_1("benHaos", "Ben", "Jon", "Haos", 43, 'M', "4142021234", 12345);
    	//$insert_var_2.create$insert_var_1("entHaos", "Joe", "Jack", "Henry", 18, 'M', "1234567890", 54321);
        
        get("/", (request, response) -> {
           Map<String, Object> viewObjects = new HashMap<String, Object>();
           viewObjects.put("title", "Welcome to Spark Project");
           viewObjects.put("templateName", "home.ftl");
           return new ModelAndView(viewObjects, "main.ftl");
        }, new FreeMarkerEngine());
        
        get("/create$insert_var_1", (request, response) -> {
           Map<String, Object> viewObjects = new HashMap<String, Object>();
           viewObjects.put("templateName", "create$insert_var_8.ftl");
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
                    if($insert_var_2.check$insert_var_1(u.get$index_param_upper_case())) {
                    int id = $insert_var_2.create$insert_var_1$param_insert;
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
        
        get("/getAll$insert_var_4", (request, response) -> {
            response.status(200);
            Map<String, Object> viewObjects = new HashMap<String, Object>();
            viewObjects.put("templateName", "show$insert_var_1.ftl");
            return new ModelAndView(viewObjects, "main.ftl");
        }, new FreeMarkerEngine());

        get("/getJson$insert_var_5", (request, response) -> {
            response.status(200);
            return toJSON($insert_var_2.sendElements());
        });

        get("/remove$insert_var_1", (request, response) -> {
           Map<String, Object> viewObjects = new HashMap<String, Object>();
           viewObjects.put("templateName", "remove$insert_var_8.ftl"); 
           viewObjects.put("$insert_var_7", toJSON($insert_var_2.send$insert_var_6()));
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
           viewObjects.put("templateName", "update$insert_var_8.ftl");
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
                if(!$insert_var_2.check$insert_var_1(u.get$index_param_upper_case())) {
                    int id = $insert_var_2.update$insert_var_1$param_insert;
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
EOJ