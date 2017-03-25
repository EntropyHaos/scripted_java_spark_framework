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

// TODO : REMOVE UN-NEEDED IMPORTS! 
// TODO : Finish Commenting the imports.

// Imports for spring framework.

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.CommandLineRunner;

import org.springframework.beans.factory.annotation.Autowired;

// Imports for spark framework.

import static spark.Spark.*;
import spark.ModelAndView;
import templateEngine.FreeMarkerEngine;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.List;

import java.io.IOException;

import entities.*;
import controls.*;

@SpringBootApplication
public class Application implements CommandLineRunner{

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
    insert_var_9=$(printf "%sRepository" $entity_var)
    insert_var_10=$(printf "%sRepository" $entity_var_lower_case)
    insert_var_11=$(printf "%sIdNumber" $entity_var)
    insert_var_12=$(printf "%sByEntity%s" $entity_var $insert_var_11)
    insert_var_13=$(printf "%sIdsList" $entity_var)
    insert_var_14=$(printf "%sIdNumber" $entity_var)

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
    printf "insert_var_9 = %s\n" $insert_var_9
    printf "insert_var_10 = %s\n" $insert_var_10
    printf "insert_var_11 = %s\n" $insert_var_11
    printf "insert_var_12 = %s\n" $insert_var_12
    printf "insert_var_13 = %s\n" $insert_var_13
    printf "insert_var_14 = %s\n" $insert_var_14
    printf "\n"
    
}

function add_model_decleration(){
    local entity_var
    entity_var=$java_class_name
    
    set_vars_for_entity_to_add    
    #display_vars_for_entity_to_add
    cat  << EOT >> $java_driver_files_location_and_name
	@Autowired
	private $insert_var_9 $insert_var_10;
EOT
}

function add_mongo_db_controller_decleration(){

    cat  << EOT >> $java_driver_files_location_and_name

    	private HaosBuilderMongoController mongoController = new HaosBuilderMongoController();
EOT
}

function add_main_method(){
cat  << EOT >> $java_driver_files_location_and_name

	public static void main(String[] args) {

        // For Testing and Debug.
        boolean dBug = true;
        if (dBug) System.out.println("\nDEBUG ON IN : Application.main\n");

		SpringApplication.run(Application.class, args);

		if (dBug) display_spark_startup_text();
	}
EOT
}

function add_run_method(){
cat  << EOT >> $java_driver_files_location_and_name

	@Override
	public void run(String... args) throws Exception {
        // This allow non static method to be called from static main while
        // allowing same method to access 'autowired' repositories.

        // For Testing and Debug.
        boolean dBug = false;
        if (dBug) System.out.println("\nDEBUG ON IN : Application.run\n");

        startSparkServer();
	}
EOT

}

function add_begining_to_Server_start_method(){
cat  << EOT >> $java_driver_files_location_and_name

    private void startSparkServer() {

        // For Testing and Debug.
        boolean dBug = false;
        if (dBug) System.out.println("\nDEBUG ON IN : Application.startSparkServer\n");

        // Set vars for Spark Server.
        staticFileLocation("/public");
        port(8080); // Spark Server will run on port 8080


        // Functions for Spark Server Routes
EOT

}

function add_root_route(){
cat  << EOT >> $java_driver_files_location_and_name

        // Landing/Home Page Route.
        get("/", (request, response) -> {
           Map<String, Object> viewObjects = new HashMap<String, Object>();
           viewObjects.put("title", "Welcome to Team Five's Final Project!");
           viewObjects.put("templateName", "aHome.ftl");
           return new ModelAndView(viewObjects, "aMain.ftl");
        }, new FreeMarkerEngine());

EOT

}

function add_get_and_post_to_java_main_file(){
    local entity_var
    entity_var=$java_class_name
    
    set_vars_for_entity_to_add    
    #display_vars_for_entity_to_add
    
    cat  << EOT >> $java_driver_files_location_and_name
        get("/create$insert_var_1", (request, response) -> {
           Map<String, Object> viewObjects = new HashMap<String, Object>();
           viewObjects.put("templateName", "create$insert_var_8.ftl");
           return new ModelAndView(viewObjects, "aMain.ftl");
        }, new FreeMarkerEngine());
        
        post("/create$insert_var_1", (request, response) -> {
            ObjectMapper mapper = new ObjectMapper();
            try {
                $insert_var_1 u = mapper.readValue(request.body(), $insert_var_1.class);
                
                if (!u.isValid(u)) {
                    response.status(400);
                    return "Correct the fields";
                }
                
                if($insert_var_10.countByEntity$insert_var_14(u.getEntity$insert_var_14()) == 0) {
                    
                    int id = 1;

                    if (dBug) System.out.println("request.body() = " + request.body());
                    if (dBug) System.out.println("u = " + convertObjectToJSON(u));
                    
                    $insert_var_10.save(u);
                    response.status(200);
                    response.type("application/json");
                    return id;
                }
                else {
                    response.status(400);
                    response.type("application/json");
                    
                    return "$insert_var_1 ID Number Already Exists!!";
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
            return new ModelAndView(viewObjects, "aMain.ftl");
        }, new FreeMarkerEngine());

        get("/getJson$insert_var_5", (request, response) -> {
            response.status(200);
            return mongoController.getJSONListOfObjectsFromRepo($insert_var_10);
        });

        get("/remove$insert_var_1", (request, response) -> {
           Map<String, Object> viewObjects = new HashMap<String, Object>();
           viewObjects.put("templateName", "remove$insert_var_8.ftl");
           viewObjects.put("$insert_var_7", mongoController.getJSONListOfIdsFromRepo($insert_var_10));
           return new ModelAndView(viewObjects, "aMain.ftl");
        }, new FreeMarkerEngine());

        put("/remove$insert_var_1/:id", (request, response) -> {
            String id = request.params(":id");
            
            long numRemoved = $insert_var_10.delete$insert_var_12(id);
            
            if (numRemoved == 1){
                response.status(200);
                return "One $insert_var_1 Removed.";
            } else if (numRemoved > 1){
                response.status(200);
                String returnString = "" + numRemoved + " $insert_var_4 REMOVED!!";
                return returnString;
            }
            else {
                response.status(400);
                return "No Such $insert_var_1 Found.";
            }
        });
        
        get("/update$insert_var_1", (request, response) -> {
           Map<String, Object> viewObjects = new HashMap<String, Object>();
           viewObjects.put("templateName", "update$insert_var_8.ftl");
           return new ModelAndView(viewObjects, "aMain.ftl");
        }, new FreeMarkerEngine());
        
        post("/update$insert_var_1", (request, response) -> {
            ObjectMapper mapper = new ObjectMapper();
            
            try {
                $insert_var_1 u = mapper.readValue(request.body(), $insert_var_1.class);
                
                if (!u.isValid(u)) {
                    response.status(400);
                    return "Correct The Fields.";
                }
                if($insert_var_10.countByEntity$insert_var_14(u.getEntity$insert_var_14()) == 1) {
                    $insert_var_10.delete$insert_var_12(u.getEntity$insert_var_14());
                    $insert_var_10.save(u);
                    response.status(200);
                    response.type("application/json");
                    return 1;
                } else {
                    response.status(404);
                    return "$insert_var_1 Does Not Exists or More Than One Exists.";
                }
            } catch (JsonParseException jpe) {
                response.status(404);
                return "Exception";
            }
        });

        // Useful for testing and debuging.
        get("/getJson$insert_var_13", (request, response) -> {
            response.status(200);
            return mongoController.getJSONListOfIdsFromRepo($insert_var_10);
        });
        
EOT
}

function add_footer_to_java_main_file(){
    cat  << 'EOT' >> $java_driver_files_location_and_name
    }
    
    private String convertObjectToJSON(Object obj) {
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

    private static void display_spark_startup_text(){
    
    // Sauce : http://patorjk.com/software/taag/#p=display&f=Fire%20Font-s&t=Spark
    //       : http://stackoverflow.com/questions/5762491/how-to-print-color-in-console-using-system-out-println
        String ANSI_RESET = "\u001B[0m";
        String ANSI_GREEN = "\u001B[32m";
        String ANSI_RED = "\u001B[31m";
        String ANSI_YELLOW = "\u001B[33m";
        
        
        System.out.println("");
        System.out.println(ANSI_YELLOW + " (");
        System.out.println(" )\\ )                  )  ");
        System.out.println("(()/(         ) (   ( /(  " + ANSI_RESET);
        System.out.println(ANSI_RED + " /("+ANSI_YELLOW+"_"+ANSI_RED+")`  )  ( /( )(  )\\()) ");
        System.out.println("("+ANSI_RESET+"___"+ANSI_RED+")) /(/(  )("+ANSI_YELLOW+"_"+ANSI_RED+")(()\\(("+ANSI_YELLOW+"_"+ANSI_RED+")\\  " + ANSI_RESET);
        System.out.println("/ __|_"+ANSI_RED+"("+ANSI_RESET+"_"+ANSI_RED+")"+ANSI_RESET+"  _"+ANSI_RED+"(("+ANSI_RESET+"_"+ANSI_RED+")"+ANSI_RESET+"_"+ANSI_RED+"("+ANSI_RESET+"_"+ANSI_YELLOW+"|"+ANSI_RESET+"_"+ANSI_YELLOW+"|"+ANSI_RED+"("+ANSI_RESET+"_"+ANSI_RED+") "+ANSI_RESET);
        System.out.println("\\__ | '_ \\/ _` | '_| / / ");
        System.out.println("|___| .__/\\__,_|_| |_\\_\\ ");
        System.out.println("    |_|");
        System.out.println("");
        System.out.println(ANSI_GREEN + "ChocAn Spark Server Started!" + ANSI_RESET);
        System.out.println("");
        
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

