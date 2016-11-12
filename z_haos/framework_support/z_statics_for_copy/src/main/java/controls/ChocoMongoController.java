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
import com.mongodb.util.JSON;

import com.mongodb.MongoException;

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
    
    private String mongoDatabaseToWorkWith;
    private String collectionControlled;
    private MongoClient mongoClient;
    private MongoDatabase mongoDatabaseControlled;
    
    public ChocoMongoController(String mongoDatabaseToWorkWith) {
        this.mongoDatabaseToWorkWith = mongoDatabaseToWorkWith;
        
        this.mongoClient = new MongoClient("localhost", 27017);
        
        try {
            this.mongoDatabaseControlled = mongoClient.getDatabase(mongoDatabaseToWorkWith);
        }
        catch (MongoException e) {
        	e.printStackTrace();
        }
        //sayHello();
    }
    
    public void sayHello(){
        System.out.println("MongoDB Controller Created!");
        
        consoleDisplayCollections();
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

        try {
            MongoCollection collection = mongoDatabaseControlled.getCollection(collectionToAddObjectTo);
            Document insertDocument = Document.parse(toJSON(objectToAdd));
            collection.insertOne(insertDocument);
        } catch (MongoException e) {
        	e.printStackTrace();
        }
        
        //consoleDisplayDocumentsInCollectionsOne(collectionToAddObjectTo);
        //consoleDisplayDocumentsInCollectionsTwo(collectionToAddObjectTo);
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
        
            DB db = mongoClient.getDB(mongoDatabaseToWorkWith);
            
            DBCollection collection = db.getCollection(collectionToDisplay);
    
            DBCursor cursor = collection.find();
            
            int i = 1;
            
            while (cursor.hasNext()) { 
                System.out.println("Inserted Document: " + i); 
                System.out.println(cursor.next()); 
                i++;
            }
        
        }catch(Exception e){
            System.err.println( e.getClass().getName() + ": " + e.getMessage() );
        }
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
