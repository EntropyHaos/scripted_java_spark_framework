pom_file_write_path="$scripts_build_dir/pom.xml"

function display_pom_file_creation_location_vars(){
    printf "%s\n" "$pom_file_write_path"
}

function add_header_to_pom_file(){
    cat  << EOHT > $pom_file_write_path
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.mycompany</groupId>
    <artifactId>sparkproject</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>jar</packaging>
    <dependencies>
        <dependency>
           <groupId>com.sparkjava</groupId>
            <artifactId>spark-core</artifactId>
            <version>2.3</version>
        </dependency>
        <dependency>
            <groupId>com.sparkjava</groupId>
            <artifactId>spark-template-freemarker</artifactId>
            <version>2.3</version>
        </dependency>
        <dependency>
            <groupId>com.fasterxml.jackson.core</groupId>
            <artifactId>jackson-core</artifactId>
            <version>2.5.1</version>
        </dependency>
        <dependency>
            <groupId>com.fasterxml.jackson.core</groupId>
            <artifactId>jackson-databind</artifactId>
            <version>2.5.1</version>
        </dependency>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.10</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.easymock</groupId>
            <artifactId>easymock</artifactId>
            <version>3.3.1</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8</maven.compiler.target>
    </properties> 
    <name>SparkProject</name>
    <build>  
        <plugins>  
            <plugin>  
                <groupId>org.codehaus.mojo</groupId>  
                <artifactId>exec-maven-plugin</artifactId>  
                <version>1.2.1</version>  
                <executions>  
                    <execution>  
                    <phase>test</phase>  
                    <goals>  
                    <goal>java</goal>  
                    </goals>  
                    <configuration>  
EOHT
# Do not indent this line above here!
    
}

function add_body_to_pom_file(){
    cat  << EOBT >> $pom_file_write_path
                    <mainClass>Driver.MainClass</mainClass>  
EOBT
}

function add_footer_to_pom_file(){
    cat  << EOFT >> $pom_file_write_path
                    </configuration>  
                    </execution>  
                </executions>  
            </plugin>  
        </plugins>  
    </build>  
</project>
EOFT
}

function create_pom_file(){
    #display_pom_file_creation_location_vars
    add_header_to_pom_file
    add_body_to_pom_file
    add_footer_to_pom_file
}
