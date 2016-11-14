package controls;

import java.net.UnknownHostException;
import java.util.Date;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBObject;
import com.mongodb.DBCursor;
import com.mongodb.MongoClient;
import com.mongodb.MongoException;
import com.mongodb.MongoSocketOpenException;
import com.mongodb.util.JSON;

import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoIterable;
import com.mongodb.client.MongoCollection;

import java.io.StringWriter;
import java.io.IOException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import java.util.Set;

import org.bson.Document;

import java.util.ArrayList;
import java.util.List;
 
public class ChocoMongoController {
    
    private String mongoDatabaseToWorkWithString;
    private String collectionControlled;
    private MongoClient mongoClient;
    private MongoDatabase mongoDatabaseControlled;
    
    private boolean mongoDatabaseServerIsAvailable;
    
    public ChocoMongoController(String requestedMongoDatabaseToWorkWith) {

        mongoDatabaseToWorkWithString = requestedMongoDatabaseToWorkWith;
        
        // Create a Client
        mongoClient = new MongoClient("localhost", 27017);

        // Test if MongoDB is running. Sauce : http://stackoverflow.com/questions/36527991/how-to-check-if-mongodb-connection-is-established-with-java
        mongoDatabaseServerIsAvailable = false;
        try {
            mongoClient.getAddress();
            System.out.println("MongoDB is running.");
            mongoDatabaseServerIsAvailable = true;
        } catch(Exception  e) {
            System.out.println("MONGO DB IS NOT RUNNING!");
            mongoClient.close();
        }
        
        if (mongoDatabaseServerIsAvailable){
            try {
                mongoDatabaseControlled = mongoClient.getDatabase(mongoDatabaseToWorkWithString);
            }
            catch (MongoException e) {
            	e.printStackTrace();
            }
        }
        
        sayHello();
    }
    
    public void sayHello(){
        System.out.println("MongoDB Controller Created!");
        
        if (mongoDatabaseServerIsAvailable){
            consoleDisplayCollections();
        } else {
            System.out.println("MongoDB is NOT running!");
        }
    }

    public void consoleDisplayCollections(){


        MongoIterable<String> databaseCollections = mongoDatabaseControlled.listCollectionNames();

        System.out.println("Collections in " + mongoDatabaseControlled.getName());
        for (String collectionName : databaseCollections) {
            System.out.println(collectionName);
        }
    }
    
    public void add_new_record(Object objectToAdd){
        
        String collectionToAddObjectTo = objectToAdd.getClass().getName().replaceAll("\\.", "") + "Collection";
        
        if (mongoDatabaseServerIsAvailable){
            try {
                MongoCollection collection = mongoDatabaseControlled.getCollection(collectionToAddObjectTo);
                Document insertDocument = Document.parse(toJSON(objectToAdd));
                collection.insertOne(insertDocument);
            } catch (MongoException e) {
            	e.printStackTrace();
            }
        } else {
            System.out.println("MongoDB is NOT running! Cannot add record!!");
        }
        
        //consoleDisplayDocumentsInCollectionsOne(collectionToAddObjectTo);
        //consoleDisplayDocumentsInCollectionsTwo(collectionToAddObjectTo);
    }

    public boolean removeFromCollectionDocumentByID(String entityTypeToRemove, String entityToRemoveStringID) {
        
        String collectionToRemoveObjectFrom = "entities" + entityTypeToRemove + "Collection";
        String idString = "entity" + entityTypeToRemove + "IdNumber";
        
        boolean returnBoolean = false;

        if (mongoDatabaseServerIsAvailable){
        
            try{
            
                DB db = mongoClient.getDB(mongoDatabaseToWorkWithString);
                DBCollection collection = db.getCollection(collectionToRemoveObjectFrom);
                
                BasicDBObject removeQuery = new BasicDBObject();
                removeQuery.append(idString, entityToRemoveStringID);
                collection.remove(removeQuery);
                returnBoolean = true;
            }catch(Exception e){
                System.err.println( e.getClass().getName() + ": " + e.getMessage() );
            }
        }
        return returnBoolean;
    }

    public void consoleDisplayDocumentsInCollectionsOne(String collectionToDisplay) {
        try {
            MongoCollection<Document> collection = mongoDatabaseControlled.getCollection(collectionToDisplay);
		    List<Document> documents = (List<Document>) collection.find().into(new ArrayList<Document>());            
            
            System.out.println("Documents in " + collectionToDisplay);
            for(Document document : documents){
                   System.out.println(toJSON(document));
            }
        } catch (MongoException e) {
        	e.printStackTrace();
        }
    }

    public void consoleDisplayDocumentsInCollectionsTwo(String collectionToDisplay) {

        try{
        
            DB db = mongoClient.getDB(mongoDatabaseToWorkWithString);
            
            DBCollection collection = db.getCollection(collectionToDisplay);
    
            DBCursor cursor = collection.find();
            
            int i = 1;

            System.out.println("\nDocuments in " + collection.getName() + "\n");
            
            while (cursor.hasNext()) { 
                System.out.println("Inserted Document: " + i); 
                System.out.println(cursor.next()); 
                i++;
            }
        
        }catch(Exception e){
            System.err.println( e.getClass().getName() + ": " + e.getMessage() );
        }
    }

    public String getListOfCollectionsIDs(String entityTypeToGet) {
        
        String collectionToRemoveObjectFrom = "entities" + entityTypeToGet + "Collection";
        
        String idString = "entity" + entityTypeToGet + "IdNumber";

        String returnString = "NOT YET!";

        if (mongoDatabaseServerIsAvailable){
        
            try{
            
                DB db = mongoClient.getDB(mongoDatabaseToWorkWithString);
                DBCollection collection = db.getCollection(collectionToRemoveObjectFrom);
                DBCursor cursor = collection.find();
                
                int count = 1;
    
                //System.out.println("\nDocuments in " + collectionToMakeListInJSON + "\n");
                
                returnString = "[ ";
               
                while (cursor.hasNext()) { 

                    BasicDBObject object = (BasicDBObject) cursor.next();
                    
                    //System.out.println ("Object = " + object.getString(idString));

                    if (count > 1){
                        returnString += " , ";
                    }
                    
                    String temp = "";
                    
                    temp = "\"" + object.getString(idString) + "\"";
                    returnString += temp;
                    count++;
                }
                returnString += " ]";

                System.out.println("\nreturnString = \n" + returnString + "\n");
            }catch(Exception e){
                System.err.println( e.getClass().getName() + ": " + e.getMessage() );
            }
        }
        
        return returnString;
    }

    public String getCollectionListJSON(String entityTypeToGet){

        String collectionToMakeListInJSON = "entities" + entityTypeToGet + "Collection";
        
        String returnString = "NO MONGO!";

        if (mongoDatabaseServerIsAvailable){
        
            try{
            
                DB db = mongoClient.getDB(mongoDatabaseToWorkWithString);
                DBCollection collection = db.getCollection(collectionToMakeListInJSON);
                DBCursor cursor = collection.find();
                
                int count = 1;
    
                //System.out.println("\nDocuments in " + collectionToMakeListInJSON + "\n");
                
                returnString = "[ \n   {";
                
                while (cursor.hasNext()) { 
    
                    if (count > 1){
                        returnString += "},\n   {";
                    }
                    String temp = "" + cursor.next();
                    temp = temp.substring((temp.indexOf("} , \"") + 4), (temp.lastIndexOf("\"valid\"") - 3));
                    returnString += temp;
                    count++;
                }
                returnString += "}\n]\n";
                //System.out.println("\nreturnString = \n" + returnString + "\n");
            }catch(Exception e){
                System.err.println( e.getClass().getName() + ": " + e.getMessage() );
            }
        }

        return returnString;
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
