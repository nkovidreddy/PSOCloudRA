<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
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
<%@ page import ="com.amazonaws.services.sqs.model.ReceiveMessageResult" %>
<%@ page import ="com.amazonaws.services.sqs.model.SendMessageRequest" %>
<%@ page import ="java.io.BufferedReader" %>
<%@ page import ="java.io.IOException" %>
<%@ page import ="java.io.InputStreamReader" %>
<%@ page import ="java.net.MalformedURLException" %>
<%@ page import ="java.net.URL" %>
<%@ page import ="java.net.URLConnection" %>
<%@ page import ="java.util.Date" %>
<%@ page import ="java.util.ArrayList" %>
<%@ page import ="java.util.HashMap" %>
<%@ page import ="java.util.HashSet" %>
<%@ page import ="java.util.LinkedHashMap" %>
<%@ page import ="java.util.List" %>
<%@ page import ="java.util.Random" %>
<%@ page import ="java.util.Set" %>

<%@ page import ="com.amazonaws.AmazonClientException" %>
<%@ page import ="com.amazonaws.auth.AWSCredentials" %>
<%@ page import ="com.amazonaws.auth.profile.ProfileCredentialsProvider" %>
<%@ page import ="com.amazonaws.regions.Region" %>
<%@ page import ="com.amazonaws.regions.Regions" %>
<%@ page import ="com.amazonaws.services.cloudwatch.AmazonCloudWatchClient" %>
<%@ page import ="com.amazonaws.services.cloudwatch.model.Datapoint" %>
<%@ page import ="com.amazonaws.services.cloudwatch.model.Dimension" %>
<%@ page import ="com.amazonaws.services.cloudwatch.model.GetMetricStatisticsRequest" %>
<%@ page import ="com.amazonaws.services.cloudwatch.model.GetMetricStatisticsResult" %>
<%@ page import ="com.amazonaws.services.ec2.AmazonEC2Client" %>

<%@ page import ="com.amazonaws.services.ec2.model.DescribeImagesResult" %>
<%@ page import ="com.amazonaws.services.ec2.model.DescribeInstancesRequest" %>
<%@ page import ="com.amazonaws.services.ec2.model.DescribeInstancesResult" %>
<%@ page import ="com.amazonaws.services.ec2.model.Instance" %>
<%@ page import ="com.amazonaws.services.ec2.model.Reservation" %>

<HTML>
    <HEAD>
        <TITLE>Billing Details </TITLE>
    </HEAD>

    <BODY>
        <H1>Billing Details of Allocated Resources for all requests </H1>

        <% 
        Class.forName("com.mysql.jdbc.Driver"); 
java.sql.Connection connection = DriverManager.getConnection("jdbc:mysql://cloudtech.cafwmc855han.us-west-2.rds.amazonaws.com/cloudtech", "root", "sindhu77");

            Statement statement = connection.createStatement() ;
            ResultSet resultset = 
                statement.executeQuery("select * from Billing") ; 
           HashMap<String,Double> billMap = new HashMap<String,Double>();
            while(resultset.next()){
            	billMap.put(resultset.getString("Resource"), resultset.getDouble("Cost"));
            }
            Statement statementRes = connection.createStatement() ;
            ResultSet resultsetRes = 
                statement.executeQuery("select * from Response") ; 
        %>

        <TABLE BORDER="1">
            <TR>
                <TH>Instance Id</TH>
                <TH>Memory</TH>
                <TH>AMI</TH>
                <TH>RESPONSE TIME</TH>
                  <TH>START TIME</TH>
                    <TH>REQUEST ID</TH>
                      <TH>RESPONSE URL</TH>
                      <TH>ALGORITHM</TH>
                      <TH>CURRENT USAGE BILL</TH>
                      
            </TR>
            <% while(resultsetRes.next()){
            	double bill=0.0;
                double costperms = 0;
            	if(resultsetRes.getString(3).contains("Windows")){
            		costperms=0.45;
            	}
            	else if(resultsetRes.getString(3).contains("Linux")){
            		costperms=0.35;
            	}
            	else{
            		costperms=0.25;	
            	}
            	
            	if(resultsetRes.getDouble(4)<3)
            		bill= bill + costperms*2*resultsetRes.getDouble(4);
            	else if(resultsetRes.getDouble(4)<5)
            		bill= bill + costperms*1.5*resultsetRes.getDouble(4);
            	else
            		bill= bill + costperms*1.1*resultsetRes.getDouble(4);
            	
            	//Calculating Difference of Timestamps
            	java.util.Date date= new java.util.Date();
	        	DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
            	String startTime = resultsetRes.getTimestamp(5).toString();
	        	String currTime = new Timestamp(date.getTime()).toString(); 
            	Date startd1 = df.parse(startTime);
            	Date currentd2 = df.parse(currTime);  
				long diffInMilliseconds = Math.abs(currentd2.getTime() - startd1.getTime());  
            	double minutesdiff= diffInMilliseconds/60000.0;
				//out.println("Difference in Milliseconds=" +diffInMilliseconds);
				bill=bill+costperms*minutesdiff;
				bill=bill/100.0;
             	%>
            <TR>
                <TD> <%= resultsetRes.getString(1) %></td>
                 <TD> <%=resultsetRes.getDouble(2) %></td>
                <TD> <%= resultsetRes.getString(3) %></TD>
                <TD> <%=resultsetRes.getDouble(4) %></td>
                <TD> <%= resultsetRes.getTimestamp(5) %></TD>                
                <TD> <%= resultsetRes.getString(6) %></TD>
                 <TD> <%= resultsetRes.getString(7) %></TD>
                  <TD> <%= resultsetRes.getString(8) %></TD>
                  <TD> <%=bill %></TD>
            </TR>
            <% } %>
        </TABLE>
    </BODY>
</HTML>