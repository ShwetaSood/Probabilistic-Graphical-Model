/** Import statements for il1 classes. */
import edu.ucla.belief.*;
import edu.ucla.belief.inference.*;
import edu.ucla.belief.inference.map.*;
import edu.ucla.belief.io.NetworkIO;
import edu.ucla.util.*;

/** Import statements for standard Java classes. */
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.io.FileReader;
import java.util.Arrays;
import com.opencsv.CSVReader;
import java.io.FileNotFoundException;
import java.util.HashMap;
/**
  This class contains code for a MAP query
*/
public class MAPTutorial
{
  /** Test. */
  @SuppressWarnings("resource")
  public static void main(String[] args) 
  {
    MAPTutorial T = new MAPTutorial();
   
      try {
          T.doMAP( T.readNetworkFile());
      } catch (Exception ex) {
          Logger.getLogger(MAPTutorial.class.getName()).log(Level.SEVERE, null, ex);
      }
  }

  /**
     MAP queries on data.
  */
  public void doMAP( BeliefNetwork bn ) throws Exception
  {
      CSVReader reader;
      reader = new CSVReader(new FileReader("C:\\Users\\Shweta sood\\Desktop\\Shweta\\matrix_shweta_data.csv"), ',' , '"' , 0);
       
      //Read CSV line by line and use the string array as you want
      String[] nextLine;
      StringBuilder str = new StringBuilder();
      HashMap h=new HashMap();
      int i=1;
      while ((nextLine = reader.readNext()) != null) 
      {
         if (nextLine != null) 
         {    
             for (String each : nextLine) 
             {
                 if(!each.equals(""))
                 {
                    str.append(each).append(",");
                    h.put(i,each);
                    i++;
                 }
             }
             break;
         } 
       }
     System.out.println(h.size());

    /* Define evidence, by id. */
    Map evidence = new HashMap(1);
    FiniteVariable var = null;
    var = (FiniteVariable) bn.forID( "MA_2015" );
    System.out.println(var.instances());
    for (Object v : var.instances())
    {
         
        System.out.println(v.toString()+"??");
    
    evidence.clear();
    evidence.put(var, v); 
    //evidence.put( var, var.instance("Y" ) );
    System.out.println(evidence);
    /* Define the set of MAP variables, by id. */
    Set setMAPVariables = new HashSet();
    
      i=1;
      int cnt=1,f=0;
      String[] arrayMAPVariableIDs = new String[100];
      reader = new CSVReader(new FileReader("C:\\Users\\Shweta sood\\Desktop\\Shweta\\matrix_shweta_data.csv"), ',' , '"' , 0);
      reader.readNext(); 
       while ((nextLine = reader.readNext()) != null)
      {
         if (nextLine != null) 
         {
             i=0;
             if(cnt==5) //replace with loop
             {
                System.out.println(Arrays.toString(nextLine));
                System.out.println("Markov Blanket for "+h.get(cnt)+" is : ");
                for (String each : nextLine) 
                {

                    if(each.equals("1"))
                    {
                       arrayMAPVariableIDs[f]=(String) h.get(i);
                       f++;

                    }
                    i++;
                }
             }
             cnt++;
         }
      }
       
    
    //String[] arrayMAPVariableIDs = new String[] { "Comm_status_change_ind", "Comm_status_2015" };
    for(  i=0; i<f; i++ ){
      setMAPVariables.add( bn.forID( arrayMAPVariableIDs[i] ) );
    }

    /* Approximate MAP. */
 
    /* Prune first. */
    BeliefNetwork networkUnpruned = bn;
    Set varsUnpruned = setMAPVariables;
    Map evidenceUnpruned = evidence;
    Map oldToNew = new HashMap( networkUnpruned.size() );
    Map newToOld = new HashMap( networkUnpruned.size() );
    Set queryVarsPruned = new HashSet( varsUnpruned.size() );
    Map evidencePruned = new HashMap( evidenceUnpruned.size() );
    System.out.println(networkUnpruned.size());
    BeliefNetwork networkPruned = Prune.prune( networkUnpruned, varsUnpruned, evidenceUnpruned, oldToNew, newToOld, queryVarsPruned, evidencePruned );

    BeliefNetwork bn2;
    bn2 = networkPruned;
    setMAPVariables = queryVarsPruned;
    evidence = evidencePruned;
   
    /* Construct the right kind of inference engine. */
    JEngineGenerator generator = new JEngineGenerator();
    JoinTreeInferenceEngineImpl engine = generator.makeJoinTreeInferenceEngineImpl( bn2, new JoinTreeSettings() );

    /* Set evidence. */
    try{
      bn2.getEvidenceController().setObservations( evidencePruned );
    }catch( StateNotFoundException e ){
      System.err.println( "Error, failed to set evidence: " + e );
      return;
    };
    
    /*
      Define the search method, one of:
        HILL (Hill Climbing), TABOO (Taboo Search)
    */
    SearchMethod searchmethod = SearchMethod.TABOO;

    /*
      Define the initialization method, one of:
        RANDOM (Random), MPE (MPE), ML (Maximum Likelihoods), SEQ (Sequential)
    */
    InitializationMethod initializationmethod = InitializationMethod.SEQ;

    /* Define a limit on the number of search steps (default 25). */
    int steps = 25;

    /* Construct a MapRunner and run the query. */
    MapRunner maprunner = new MapRunner();
    MapRunner.MapResult mapresult = maprunner.approximateMap( bn2, engine, setMAPVariables, evidence, searchmethod, initializationmethod, steps );
    Map instantiation = mapresult.instantiation;
    double score = mapresult.score;

    /* Print the results. */
    System.out.println( "Approximate MAP, P(MAP,e)= " + score );
    System.out.println( "\t P(MAP|e)= " + ( score/engine.probability() ) );
    VariableImpl.setStringifier( AbstractStringifier.VARIABLE_ID );
    System.out.println( "\t instantiation: " + instantiation );

    /* Print timings. */
    System.out.println();
    System.out.println( "Initialization time, cpu: " + mapresult.initDurationMillisProfiled + ", elapsed: " + mapresult.initDurationMillisElapsed );
    System.out.println( "Search time, cpu: " + mapresult.searchDurationMillisProfiled + ", elapsed: " + mapresult.searchDurationMillisElapsed );
    System.out.println();
    System.out.println(instantiation.values());
 
    /* Clean up to avoid memory leaks. */
    engine.die();
  }
    return;
  }

  /**
    Open the network file.
  */
  public BeliefNetwork readNetworkFile()
  {
    String path = "C:\\Users\\Shweta sood\\Desktop\\Shweta\\GAF_Master_Shweta_59_shweta.net";

    BeliefNetwork ret = null;
    try{
      /* Use NetworkIO static method to read network file. */
      ret = NetworkIO.read( path );
    }catch( Exception e ){
      System.err.println( "Error, failed to read \"" + path + "\": " + e );
      return (BeliefNetwork)null;
    }
    return ret;
  }
}
