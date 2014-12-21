package action;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

import com.amazonaws.AmazonClientException;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.policy.actions.CloudWatchActions;
import com.amazonaws.auth.profile.ProfileCredentialsProvider;
import com.amazonaws.metrics.internal.cloudwatch.CloudWatchMetricConfig;
import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.autoscaling.model.DescribeMetricCollectionTypesResult;
import com.amazonaws.services.cloudwatch.AmazonCloudWatchClient;
import com.amazonaws.services.cloudwatch.model.Datapoint;
import com.amazonaws.services.cloudwatch.model.Dimension;
import com.amazonaws.services.cloudwatch.model.GetMetricStatisticsRequest;
import com.amazonaws.services.cloudwatch.model.GetMetricStatisticsResult;
import com.amazonaws.services.ec2.AmazonEC2Client;
import com.amazonaws.services.ec2.model.DescribeImagesRequest;
import com.amazonaws.services.ec2.model.DescribeInstancesRequest;
import com.amazonaws.services.ec2.model.Instance;


public class listOfImages {

	public static void main(String[] args) {
		AWSCredentials credentials = null;
	    try {
	        credentials = new ProfileCredentialsProvider("default").getCredentials();
	    } catch (Exception e) {
	        throw new AmazonClientException(
	                "Cannot load the credentials from the credential profiles file. " +
	                "Please make sure that your credentials file is at the correct " +
	                "location (/Users/KovidReddy/.aws/credentials), and is in valid format.",
	                e);
	    }
	    AmazonEC2Client amazonEC2Client = new AmazonEC2Client(credentials);
	    Region usWest1 = Region.getRegion(Regions.US_WEST_2);
	    amazonEC2Client.setRegion(usWest1);
	    DescribeInstancesRequest request1 = new DescribeInstancesRequest();
	   // System.out.println("Instane ID=" +amazonEC2Client.describeInstances());
	    //CloudWatchMetricConfig metricsConf = new CloudWatchMetricConfig();
	    //System.out.println("Metrics Size="+metricsConf.getMetricQueueSize());
	    //CloudWatchActions.ListMetrics();
	    //DescribeMetricCollectionTypesResult metricRes = new DescribeMetricCollectionTypesResult();
	    //System.out.println(metricRes.getMetrics());
	   // LinkedHashMap<Date,Double> map=(LinkedHashMap<Date, Double>) new HashMap<Date,Double>();
	    LinkedHashMap<Date,Double> map=new LinkedHashMap<Date, Double>();
	    //AmazonCloudWatchClient cloudWatch = new AmazonCloudWatchClient(new BasicAWSCredentials(AccessKey,SecretKey));
	    AmazonCloudWatchClient cloudWatch = new AmazonCloudWatchClient(credentials);
	    cloudWatch.setEndpoint("monitoring.us-west-2.amazonaws.com");
	    long offsetInMilliseconds = 1000 * 60 * 60 * 24;
	    Dimension instanceDimension = new Dimension();
	    instanceDimension.setName("instanceid");
	    instanceDimension.setValue("i-b58e327c");
	    
	    System.out.println("Step2");

	   /* GetMetricStatisticsRequest request = new GetMetricStatisticsRequest()
	            .withStartTime(new Date(new Date().getTime() - offsetInMilliseconds))
	            .withNamespace("AWS/EC2")
	            .withPeriod(60 * 60)
	            .withMetricName("CPUUtilization")
	            .withStatistics("Average")
	            .withDimensions(Arrays.asList(instanceDimension))
	            .withEndTime(new Date());*/
	    
	    System.out.println("Time= " +new Date(new Date().getTime() - offsetInMilliseconds/225) + "Time again"
	    		+ "=" + new Date());
	    GetMetricStatisticsRequest request = new GetMetricStatisticsRequest()
        .withStartTime(new Date(new Date().getTime() - offsetInMilliseconds/225))
	    .withNamespace("AWS/EC2")
        .withPeriod(5 * 60)
        .withMetricName("CPUUtilization")
        .withStatistics("Maximum")
        .withDimensions(new Dimension().withName("InstanceId").withValue("i-b58e327c"))
        .withEndTime(new Date());
	    
	    
	    
System.out.println("Step3");
	    GetMetricStatisticsResult getMetricStatisticsResult = cloudWatch.getMetricStatistics(request);
	    System.out.println(getMetricStatisticsResult);
System.out.println("Step4");
	    //To read the Data
System.out.println(getMetricStatisticsResult.getDatapoints().get(0));
	    for (Datapoint dp : getMetricStatisticsResult.getDatapoints()) {
	        map.put(dp.getTimestamp(), dp.getMaximum());   //or getMaximum() or whatever Statistics you are interested in. You can also maintain a list of the statistics you are interested in. Ex: request.setStatistics(list) 
	        //System.out.println(map);
	    }
	    
	    /*  //Instance newInst = new Instance();
	    newInst.setInstanceId("i-ebf6b521");
	    System.out.println("\n");
	    System.out.println(newInst.getInstanceId());
	    System.out.println(newInst.toString());
	    System.out.println("Public DNS Name:" +newInst.getPublicDnsName());
	    System.out.println("Public IP Address :" +newInst.getPublicIpAddress());
	    //getLaunchTime */
	    //Instance newInstance = new Instance();
	    //newInstance.getInstanceId();
		//DescribeImagesRequest listOfImgs = new DescribeImagesRequest();
		//System.out.println(amazonEC2Client.describeImages());
	/*	 List<String> listofImagesDesc = listOfImgs.getImageIds();
		 System.out.println(listofImagesDesc.size());
		 for(int i=0;i<listofImagesDesc.size();i++){
			System.out.println(listofImagesDesc.get(i));
		 }
		 System.out.println("Done"); */
	}
}
