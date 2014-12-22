package action;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Random;
import java.util.Set;

import sun.org.mozilla.javascript.internal.ast.ReturnStatement;

import com.amazonaws.AmazonClientException;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.auth.profile.ProfileCredentialsProvider;
import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.cloudwatch.AmazonCloudWatchClient;
import com.amazonaws.services.cloudwatch.model.Datapoint;
import com.amazonaws.services.cloudwatch.model.Dimension;
import com.amazonaws.services.cloudwatch.model.GetMetricStatisticsRequest;
import com.amazonaws.services.cloudwatch.model.GetMetricStatisticsResult;
import com.amazonaws.services.ec2.AmazonEC2Client;
import com.amazonaws.services.ec2.model.DescribeImagesResult;
import com.amazonaws.services.ec2.model.DescribeInstancesRequest;
import com.amazonaws.services.ec2.model.DescribeInstancesResult;
import com.amazonaws.services.ec2.model.Instance;
import com.amazonaws.services.ec2.model.Reservation;
import com.amazonaws.services.sqs.AmazonSQS;
import com.amazonaws.services.sqs.AmazonSQSClient;
import com.amazonaws.services.sqs.model.DeleteMessageRequest;
import com.amazonaws.services.sqs.model.Message;
import com.amazonaws.services.sqs.model.ReceiveMessageRequest;
import com.amazonaws.services.sqs.model.ReceiveMessageResult;

public class PSOAlgorithm {

	public String runPSO() throws ClassNotFoundException, SQLException{
		
	 AWSCredentials credentials = null;
	 String returnMsg = null;

		try {
			BasicAWSCredentials credentials1 = new BasicAWSCredentials("username","acceskey");
			credentials  = credentials1;
			} catch (Exception e) {
		    throw new AmazonClientException(
		            "Cannot load the credentials from the credential profiles file. " +
		            "Please make sure that your credentials file is at the correct " +
		            "location (/Users/KovidReddy/.aws/credentials), and is in valid format.",
		            e);
		}

		
		//credentials have been removed for security purposes as we are using amazon
		Class.forName("com.mysql.jdbc.Driver"); 
		java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://cloudaddress","root","root");
		//Receive requests from SQS
		AmazonSQS sqs = new AmazonSQSClient(credentials);
		Region usWest2 = Region.getRegion(Regions.US_WEST_2);
		sqs.setRegion(usWest2);
		String requestQueueURL = "https://sqs.us-west-2.amazonaws.com/066339621334/PSOQueue";
		
		//lISTING Queues
		 //System.out.println("Listing all queues in your account.\n");
		  
		 // Receive messa
		 //Use While
		    //System.out.println("Receiving messages from MyQueue.\n");
		    ReceiveMessageRequest receiveMessageRequest = new ReceiveMessageRequest(requestQueueURL);
		    //ReceiveMessageResult receiveMessageResponse =  sqs.receiveMessage(receiveMessageRequest);    
			
		    List<Message> messages = sqs.receiveMessage(receiveMessageRequest).getMessages();
			returnMsg = messages.toString();
		    while(!messages.isEmpty()){
			//List<Message> messages= receiveMessageResponse.getMessages();
		    String Resource = null;
		    String reqId = null;
		    String reqMemory=null;
		    String Location = null;
		    String Time=null;
		    String Platform = null;
		    String Type=null;
		    for (Message message : messages) {
		        String fullMsg = message.getBody();
		        String strSplit[]= fullMsg.split(";");
		        reqId=strSplit[0];
		        Resource=strSplit[1];
		        reqMemory=strSplit[2];
		        Location=strSplit[3];
		        Time=strSplit[4];
		        Platform=strSplit[5];
		        Type=strSplit[6];
		           }

		    //Connection to Instances SQL
		Statement st= con.createStatement(); 
		returnMsg= returnMsg + "select InstID,AMI,Memory,URL,cpuLoad,Zone from Instance WHERE AMI='"+Platform+"'"+" AND Memory >='"+reqMemory+"'";
		ResultSet rs=st.executeQuery("select InstID,AMI,Memory,URL,cpuLoad,Zone from Instance WHERE AMI='"+Platform+"'"+" AND Memory >='"+reqMemory+"'"); 
		ArrayList instanceIds = new ArrayList();
		HashMap<String, Integer> instanceLoad = new HashMap<String, Integer>();
		HashMap<String, Double> instanceMem = new HashMap<String, Double>();
		HashMap<String, String> instanceURL = new HashMap<String, String>();
		while(rs.next()){
			returnMsg= returnMsg + "In rs.next";
			  instanceIds.add(rs.getString("InstID"));
			  instanceLoad.put(rs.getString("InstID"),rs.getInt("cpuLoad"));
			  instanceMem.put(rs.getString("InstID"), rs.getDouble("Memory"));
			  instanceURL.put(rs.getString("InstID"),rs.getString("URL"));
			  for(int i=0;i<instanceIds.size();i++){
				 //System.out.println(instanceIds.get(i));
			 }
		}

		int i = 0, networkMsg=0;
		double velocity=-1;
		String initialHostID;
		String destHostID;
		long initTime = System.currentTimeMillis();
		
			//System.out.println("InitTime="+initTime);
			//System.out.println("\n");
			//System.out.println("Resource allocation of virtual machine for mobile request:"+(+1)+"\n");
		if(instanceIds.size()>0){	
		initialHostID = getInitialHost(instanceIds);
			destHostID=initialHostID;
			double currentPositionLoad= calculateTotalLoad(initialHostID, instanceLoad);
			ArrayList<String> hostNeigh = getNeighbours(initialHostID, instanceIds);
			i=0;
			while(i<hostNeigh.size()){
				returnMsg= returnMsg + "In while loop size="+hostNeigh.size();
				 
				String neighbourId;
				neighbourId=hostNeigh.get(i);
				double destPositionLoad = calculateTotalLoad(neighbourId, instanceLoad);
				networkMsg++;
				if(destPositionLoad==0){
					currentPositionLoad=destPositionLoad;
					destHostID=hostNeigh.get(i);
					i=hostNeigh.size();
				}
				if(destPositionLoad!=0 && currentPositionLoad-destPositionLoad>velocity){
					velocity=currentPositionLoad-destPositionLoad;
					currentPositionLoad=destPositionLoad;
					destHostID=hostNeigh.get(i);
				}
				i++;
			}
			//Allocate host now
			String allocatedHostID = destHostID;
			int newProcPower=(int) (3.8 + instanceLoad.get(allocatedHostID));
			instanceLoad.put(allocatedHostID,newProcPower);
			Statement updState= con.createStatement(); 
			returnMsg= returnMsg + "Updating Database Below";
			double memory = instanceMem.get(allocatedHostID);
			double netmemory = memory- Double.parseDouble(reqMemory);
			updState.executeUpdate("UPDATE Instance SET cpuLoad='"+newProcPower+"'"+",Memory='"+netmemory+"'"+" WHERE InstID='"+allocatedHostID+"'"); 
			returnMsg= returnMsg + "After Update";
			
			//Insert into Response 
			Statement insResponse= con.createStatement(); 
			long endTime = System.currentTimeMillis();
			double respTime = endTime-initTime;
			Calendar calendar = Calendar.getInstance();
		    java.sql.Timestamp startTimeofRequest = new java.sql.Timestamp(calendar.getTime().getTime());
		    
		    //Instance allocInst = new Instance();
		    //allocInst.setInstanceId(allocatedHostID);
		    String publicURL = instanceURL.get(allocatedHostID);
		    returnMsg=returnMsg + "INSERT INTO Response (resInstID,resMemory,AMI,resTime,startTime,"
		    		+ "reqId,URL) VALUES('"+allocatedHostID+"','"+reqMemory+"','"+Resource+"','"+respTime+"','"
		    		+startTimeofRequest+"','"+reqId+"','"+publicURL+"')";
		    String reqAlgo = "PSOAlgorithm";
		   insResponse.executeUpdate("INSERT INTO Response (resInstID,resMemory,AMI,resTime,startTime,"
		    		+ "reqId,URL,Algorithm) VALUES('"+allocatedHostID+"','"+reqMemory+"','"+Resource+"','"+respTime+"','"
		    		+startTimeofRequest+"','"+reqId+"','"+publicURL+"','"+reqAlgo+"')");
			// Delete a message
	          //  System.out.println("Deleting a message.\n");
			String messageRecieptHandle = messages.get(0).getReceiptHandle();
	        sqs.deleteMessage(new DeleteMessageRequest(requestQueueURL, messageRecieptHandle));
			
			//Update in mysql with the load
			//System.out.println("Initial Host Value="+initialHostID);
			//System.out.println("MB: " + (double) (Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory()) / (1024*1024));
		
		//System.out.println("MB: " + (double) (Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory()) / (1024*1024));
		}
			//System.out.println("Resource Allocation Time:" +(endTime-initTime));
		messages = sqs.receiveMessage(receiveMessageRequest).getMessages();
			}
	return returnMsg;	
	}
	
	int getHostBasedOnUtilization(ArrayList<Integer> hostList){
		int hostValUtil = 0,noOfHostsAMI=0;
		for(int j=0;j<hostList.size();j++){
			int noOfHostsAMITemp = getNumberOfHostsOnAmi(hostList.get(j));
			if(noOfHostsAMITemp>noOfHostsAMI){
				hostValUtil = hostList.get(j);
			}
		}
		return hostValUtil;
	}
	
	int getHostBasedOnCost(ArrayList<Integer> hostList){
		int hostValUtil = 0,costPerAMI=0;
		for(int j=0;j<hostList.size();j++){
			int costPerAMITemp = getCostOfHostOnAmi(hostList.get(j));
			if(costPerAMITemp>costPerAMI){
				hostValUtil = hostList.get(j);
			}
		}
		return hostValUtil;
	}
	
	int getHostBasedOnLocation(ArrayList<Integer> hostList){
		int longitude = 0, latitude=0;
			ArrayList<Integer> locationHost = getAvailableHosts(longitude,latitude);
			Random randGen = new Random();
			int value = randGen.nextInt(locationHost.size());
			return (Integer) locationHost.get(value);
	}
	
	
	ArrayList<Integer> getAvailableHosts(int longitude, int latitude) {
		ArrayList<Integer> locationHost = null;
		return locationHost;
	}

	int getCostOfHostOnAmi(int value){
		return 0;
	}
	
	int getNumberOfHostsOnAmi(int value){
		return 0;
	}
	
 String getInitialHost(ArrayList<String> instanceIds){
		Random randGen = new Random();
		int value = randGen.nextInt(instanceIds.size());
		return instanceIds.get(value);
	}

 double calculateTotalLoad(String initialHostID,HashMap<String, Integer> instanceLoad){
	double loadVal=0.0;
	loadVal = getProcPowerForHostId(initialHostID,instanceLoad);
	return loadVal;
 }
 
 int getProcPowerForHostId(String initialHostID, HashMap<String, Integer> instanceLoad){
	 	 return instanceLoad.get(initialHostID);
 }
 
 void setProcPowerForHostId(int hostid,int value,HashMap<Integer,Integer> hostProcVal){
	 hostProcVal.put(hostid, value);
 }
 
 ArrayList getNeighbours(String initialHostID,ArrayList<String> instanceIds){
	 ArrayList<String> neighbourHostList = new ArrayList<String>();
	 for(String inst: instanceIds){
		 if(inst.equalsIgnoreCase(initialHostID))
			 neighbourHostList.add(inst);
	 }
 return neighbourHostList;
 
 
 }

}
