/** Import statements for il1 classes. */
import edu.ucla.belief.*;
import edu.ucla.belief.inference.*;
import edu.ucla.belief.inference.map.*;
import edu.ucla.belief.io.NetworkIO;
import edu.ucla.util.*;

/** Import statements for il2 classes. */
import il2.inf.map.MapSearch;

/** Import statements for standard Java classes. */
import java.util.*;

/**
  This class demonstrates code for a MAP query

  To compile this class, make sure
  inflib.jar occurs in the command line classpath,
  e.g. javac -classpath inflib.jar MAPTutorialEXACT.java

  To run it, do the same,
  but also include the path to
  the compiled class,
  e.g. java -classpath .:inflib.jar MAPTutorialEXACT

  @author Keith Cascio
  @since 9 Jun, 2015 2:48:41 PM
*/
public class MAPTutorialEXACT
{
  /** Test. */
  public static void main(String[] args){
    MAPTutorialEXACT T = new MAPTutorialEXACT();
    T.doMAP( T.readNetworkFile() );
  }

  /**
    Demonstrates a MAP query.
  */
  public void doMAP( BeliefNetwork bn )
  {
    /* Define evidence, by id. */
    Map evidence = new HashMap(1);
    FiniteVariable var = null;
    var = (FiniteVariable) bn.forID( "OPEN_TO_NEW_BIZ_" );
    evidence.put( var, var.instance( "Y" ) );

    /* Define the set of MAP variables, by id. */
    Set setMAPVariables = new HashSet();
    String[] arrayMAPVariableIDs = new String[] { "Microsite_Activity_ind_2015", "Microsite_Activity_ind_2013", "Email_status_ind_2015", "MARKET_SEGMENT", "ES_Mail_status_ind_2014", "MA_2014", "Microsite_Activity_ind_2014", "ES_Reg_Mail_ind_2015", "Onsite_Event_ind_2015", "MA_2015", "ES_Mail_status_ind_2015", "Comm_status_2014", "Email_status_ind_2014", "Comm_status_change_ind", "Mail_status_ind_2014", "Mail_status_ind_2015", "Comm_status_2015", "ES_Reg_Mail_ind_2014" };
    for( int i=0; i<arrayMAPVariableIDs.length; i++ ){
      setMAPVariables.add( bn.forID( arrayMAPVariableIDs[i] ) );
    }

    /* Calculate MAP exactly. */

    /* Define a time limit in seconds (default 60). 0 means no limit. */
    int timeoutsecs = 60;

    /* Define a width barrier (default 0). 0 means no limit. */
    int widthbarrier = 0;

    /* Call static ExactMap method (unsloppy version). */
    MapSearch.MapInfo mapinfo = ExactMap.computeMap( bn, setMAPVariables, evidence, timeoutsecs, widthbarrier );
    MapSearch.MapResult exactmapresult = (MapSearch.MapResult) mapinfo.results.iterator().next();
    Map instantiation = exactmapresult.getConvertedInstatiation();
    double score = exactmapresult.score;
    boolean flagExact = mapinfo.finished;

    /* Print the results. */
    System.out.println( "Exact MAP, P(MAP,e)= " + score );
    VariableImpl.setStringifier( AbstractStringifier.VARIABLE_ID );
    System.out.println( "\t instantiation: " + instantiation );
    if( flagExact ) System.out.println( "\t Result is guaranteed exact." );
    else System.out.println( "\t Result is not guaranteed exact." );

    /* Print timings. */
    System.out.println();
    System.out.println( "Pruning time, cpu: " + mapinfo.pruneDurationMillisProfiled + ", elapsed: " + mapinfo.pruneDurationMillisElapsed );
    System.out.println( "Initialization time, cpu: " + mapinfo.initDurationMillisProfiled + ", elapsed: " + mapinfo.initDurationMillisElapsed );
    System.out.println( "Search time, cpu: " + mapinfo.searchDurationMillisProfiled + ", elapsed: " + mapinfo.searchDurationMillisElapsed );
    System.out.println();

    return;
  }

  /**
    Open the network file used to create this tutorial.
  */
  public BeliefNetwork readNetworkFile()
  {
    String path = "/home/hduser/GAF_Master_Shweta_59_shweta.net";

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
