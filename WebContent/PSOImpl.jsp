<%@page import="action.ArtificialBee"%>
<%@page import="action.AntColony"%>
<%@page import="action.PSOAlgorithm"%>
<%@page import="action.LocationAware"%>
<%@page import="com.amazonaws.auth.BasicAWSCredentials"%>
<%@ page import ="java.sql.*" %>
<%@ page import ="javax.sql.*" %>

<%@ page import ="java.util.List" %>

<%@ page import ="java.util.Map.Entry" %>
<%@ page import ="com.amazonaws.AmazonClientException" %>
<%@ page import ="com.amazonaws.AmazonServiceException" %>
<%@ page import ="com.amazonaws.auth.AWSCredentials" %>
<%@ page import ="com.amazonaws.auth.profile.ProfileCredentialsProvider" %>
<%@ page import ="com.amazonaws.regions.Region" %>
<%@ page import ="com.amazonaws.regions.Regions" %>
<%@ page import ="com.amazonaws.services.sqs.AmazonSQS" %>
<%@ page import ="com.amazonaws.services.sqs.AmazonSQSClient" %>
<%@ page import ="com.amazonaws.services.sqs.model.CreateQueueRequest" %>
<%@ page import ="com.amazonaws.services.sqs.model.DeleteMessageRequest" %>
<%@ page import ="com.amazonaws.services.sqs.model.DeleteQueueRequest" %>
<%@ page import ="com.amazonaws.services.sqs.model.Message" %>
<%@ page import ="com.amazonaws.services.sqs.model.ReceiveMessageRequest" %>
<%@ page import ="com.amazonaws.services.sqs.model.SendMessageRequest" %>
<%
//String userid=request.getParameter("user"); 
//session.putValue("userid",userid); 
//String pwd=request.getParameter("pwd"); 
Class.forName("com.mysql.jdbc.Driver");
//credentials have been commented for security purposes
java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://cloudadress","root","root");
Statement st= con.createStatement(); 
ResultSet rs=st.executeQuery("select * from request"); 


/*
 * The ProfileCredentialsProvider will return your [default]
 * credential profile by reading from the credentials file located at
 * (/Users/KovidReddy/.aws/credentials).
 */
AWSCredentials credentials = null;

try {
	out.println("hey");
//credentials have been commented for security purposes
	
	BasicAWSCredentials credentials1 = new BasicAWSCredentials("accessid","accesskey");
	out.println("yo");
	
	credentials  = credentials1;
	out.println(credentials.getAWSAccessKeyId());
	
	//credentials1 = new ProfileCredentialsProvider("default").getCredentials();
} catch (Exception e) {
    throw new AmazonClientException(
            "Cannot load the credentials from the credential profiles file. " +
            "Please make sure that your credentials file is at the correct " +
            "location (/Users/KovidReddy/.aws/credentials), and is in valid format.",
            e);
}

AmazonSQS sqs = new AmazonSQSClient(credentials);
Region usWest2 = Region.getRegion(Regions.US_WEST_2);
sqs.setRegion(usWest2);

out.println("===========================================");
out.println("Getting Started with Amazon SQS");
out.println("===========================================\n");

try {
    // Create a PSO Request queue
    out.println("Creating a new SQS queue called MyQueue.\n");
    CreateQueueRequest createPSOQueueRequest = new CreateQueueRequest("PSOQueue");
    String myPSOQueueUrl = sqs.createQueue(createPSOQueueRequest).getQueueUrl();
	
    out.println("MyQueueURL=" +myPSOQueueUrl);
    // List queues
    //System.out.println("Listing all queues in your account.\n");
    for (String queueUrl : sqs.listQueues().getQueueUrls()) {
        out.println("  QueueUrl: " + queueUrl);
    }
    out.println();

    // Send a message
   out.println("Sending a message to MyQueue.\n");
   //establish mysql connection - cloud
   String requestMsgBdy = null; 
   while(rs.next()){
	   requestMsgBdy=rs.getInt("reqId")+";"+rs.getString("Resource")+";"+rs.getString("Memory")+";"+rs.getString("Location")+";"+ rs.getString("Time")+";"+rs.getString("Platform")+";"+rs.getString("Type")+";"+rs.getString("Latitude")+";"+rs.getString("Longitude")+";";
	   sqs.sendMessage(new SendMessageRequest(myPSOQueueUrl,requestMsgBdy));
	   
   }
} catch (AmazonServiceException ase) {
    out.println("Caught an AmazonServiceException, which means your request made it " +
            "to Amazon SQS, but was rejected with an error response for some reason.");
    out.println("Error Message:    " + ase.getMessage());
    out.println("HTTP Status Code: " + ase.getStatusCode());
    out.println("AWS Error Code:   " + ase.getErrorCode());
    out.println("Error Type:       " + ase.getErrorType());
    out.println("Request ID:       " + ase.getRequestId());
} catch (AmazonClientException ace) {
    out.println("Caught an AmazonClientException, which means the client encountered " +
            "a serious internal problem while trying to communicate with SQS, such as not " +
            "being able to access the network.");
    out.println("Error Message: " + ace.getMessage());
}
//Calling PSO Load Balancer update
PSOAlgorithm psoImpl = new PSOAlgorithm();
psoImpl.runPSO();

%>