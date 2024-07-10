Here is a working version of the project.  Weirdly, the finished product does not acknowledge that it is run in a Docker container, even though it is.  The final product runs on ECS in AWS.

One note: in this repo, I am assuming certain elements pre-existing, such as the VPC and subnets, ECR repo, ECS cluster, etc., because it does not make sense to make new instances of these with every application created.

I originally tried to put this together using the container as a Lambda function, but I wasn't able to get the function to respond, so I switched gears and put it into ECS.  This is a plain vanilla implemention with an ALB in front of the ECS service.  It assumes that a VPC with 2 or more properly configured subnets are pre-existing, as are properly configured security groups.  I do it this way, because in my current world, security groups and IAM configurations are dealt with separately from application/service deployment. I also have the Docker build and upload to ECR separate and not in Terraform because Terraform doesn't really have a good solution for dealing with Docker containers - yes, one could use null resources, but all those really do is allow one to implement a shell script in Terraform, which seems an unnecessary middle man.  They should really be dealt with solutions like Packer and/or Artifactory.

Given more time, to make a more complete solution, I would wish to do the following to a "real" application:

1. Apply logging of the load balancer traffic.  In AWS, the logging is into S3; depending on the needs of the business, it may be desirable to then forward those logs into Elastic Stack/Splunk or a system like Redshift for analytics.
2. Depending on the needs of the application, potentially make the front end Cloudfront rather than an ALB.  Considerations include size and geographic spread of the customer base.
3. Create a proper URL in Route 53.
4. Put a Web Application Firewall in front of the application. Again, solutions here are not one size fits all, but at a minimum, valuable protection can be gained by using the WAF to at least block traffic from countries which are known state sponsors - or at least tolerators - of APT crews, if business needs allow.
5. Use AWS Guard Duty.
6. Properly tag all elements.  Tagging is underappreciated by many, but it should be used to track ownership and age of all deployed services, at a minimum; and real cost monitoring and analysis is impossible without it.