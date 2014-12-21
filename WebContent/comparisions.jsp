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
        <TITLE>Comparison Metrics </TITLE>
    </HEAD>

    <BODY>
        <H1 style="text-align: center;padding-bottom: 3%;">Comparisons </H1>
   <h3>Comparison based on cost</h3>
			<img src="images/Cost2.png"/>
			<h3>comparison based on response time</h3>
			<img src="images/Response2.png"/>
        
 
              
    </BODY>
</HTML>