# NS-TF-STACK
Redundant Web Container with LB and WAF hosted on AWS

Code Arch task as below:

zVPC.tf     -   VPC 
            -   Subnets

zIGW-PUB.tf -   IGW 
            -   Public Route table

zNGW-PRI.tf -   NAT GW 
            -   Private Route table
            -   EIP

zECS-Repo.tf-   ECS Cluster

zECS-Clu.tf -   ECS Repository


