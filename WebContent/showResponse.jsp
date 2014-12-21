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
        <TITLE>Results of Resource Allocation </TITLE>
    </HEAD>

    <BODY>
        <H1>Results of Resource Allocation </H1>

        <% 
        Class.forName("com.mysql.jdbc.Driver"); 
java.sql.Connection connection = DriverManager.getConnection("jdbc:mysql://cloudtech.cafwmc855han.us-west-2.rds.amazonaws.com/cloudtech", "root", "sindhu77");

            Statement statement = connection.createStatement() ;
            ResultSet resultset = 
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
            </TR>
            <% while(resultset.next()){ %>
            <TR>
                <TD> <%= resultset.getString(1) %></td>
                 <TD> <%=resultset.getDouble(2) %></td>
                <TD> <%= resultset.getString(3) %></TD>
                <TD> <%=resultset.getDouble(4) %></td>
                <TD> <%= resultset.getTimestamp(5) %></TD>                
                <TD> <%= resultset.getString(6) %></TD>
                 <TD> <%= resultset.getString(7) %></TD>
                  <TD> <%= resultset.getString(8) %></TD>
            </TR>
            <% } %>
        </TABLE>
    </BODY>
</HTML>