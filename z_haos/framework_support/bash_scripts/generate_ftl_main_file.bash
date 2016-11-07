function display_vars_for_generate_main_ftl_file(){
    echo $ftl_files_output_directory_and_main_ftl_file_name
}

function add_header_to_main_ftl_file(){

cat  << EOT > $ftl_files_output_directory_and_main_ftl_file_name
<html>
   <head>
      <title>Spark Project</title>
      <link rel="stylesheet" href="css/bootstrap.min.css">
      <link rel="stylesheet" href="css/bootstrap-theme.min.css">
      <link rel="stylesheet" href="css/starter-template.css">
   </head>
   <body>
      <div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
         <div class="container">
            <div class="navbar-header">
               <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
               <span class="sr-only">Toggle navigation</span>
               <span class="icon-bar"></span>
               <span class="icon-bar"></span>
               <span class="icon-bar"></span>
               </button>
               <a class="navbar-brand" href="#"></a>
            </div>
            <div class="collapse navbar-collapse">
               <ul class="nav navbar-nav">
                  <li class="active"><a href="/">Home</a></li>
EOT
# Do not indent this line above here!
}

function add_entity_manage_menu_to_main_ftl_file(){

java_class_name_plural=$(printf "%ss" $java_class_name)

cat  << EOT >> $ftl_files_output_directory_and_main_ftl_file_name

                  <li class="dropdown">
                     <a class="dropdown-toggle" data-toggle="dropdown" href="#">$java_class_name<span class="caret"></span></a>
                     <ul class="dropdown-menu">
                        <li><a href="create$java_class_name">Create $java_class_name</a></li>
                        <li><a href="getAll$java_class_name_plural">Get All $java_class_name_plural</a></li>
                        <li><a href="update$java_class_name">Update $java_class_name</a></li>
                        <li><a href="remove$java_class_name">Remove $java_class_name</a></li>
                     </ul>
                  </li>

EOT
}

function add_footer_to_main_ftl_file(){

cat  << EOT >> $ftl_files_output_directory_and_main_ftl_file_name
               </ul>
            </div>
            <!--/.nav-collapse -->
         </div>
      </div>
      <script src="js/jquery.min.js"></script>
      <script src="js/bootstrap.min.js"></script>
      <div class="container">
         <#include "\${templateName}">
      </div>
   </body>
</html>

EOT
# Do not indent this line above here!
}