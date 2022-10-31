# EC2_Nginx
Using Terraform to Deploy EC2 that runs nginx web server

## Important files to run Terraform /Web

| Filename | What it does |
| --- | --- |
| 0. provider.tf | set terraform to use aws and specific region |
| 1.  vpc.tf! | To create aws VPC/Network |
| 2. secgroup.tf | To allow inbound 443 traffic and port 22 so that our ec2 is configure automatically with nginx.sh file|
| 3. ec2.tf | create ec2 server that will host our nginx website |
| 4. generateKeyPair | Private KeyPair that will be associated with EC2 will be created automatically |
| 5. nginx.sh | The shell script to be used to configure the ec2 automatically |
| 
# Setup Linux Environment to run: Ubuntu
###### Install awscli
```
$ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
$ unzip awscliv2.zip
$ sudo ./aws/install
```
###### Configure AWS CLI
* You will need AWS Account
* Create IAM User with programmatic privilleges
* Download AWS Access Key Id and Secret Acees Key
* aws configure command to setup aws cli to interract with our aws resources

```
$ aws configure
```

###### Install Terraform
* Terraform is infrastructure as code  allow us to provision resources using code on any cloud platform

```
$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
$ sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
$ sudo apt update
$ sudo apt install terraform
```

##### How to Run the Project
* clone the github repository into your local computer

```
$ cd Web # the directory is inside the repository
$ terraform init # to initialize the working directory that contains configurations
$ terraform plan # to Check how the resources will be created to reach desired state of infrastructure
$ terraform apply --auto-approve # to create the resources under the plan command
```
* After the Infrastructure is created
* Public IP address for our Nginx will be output in your terminal
* Or you can access the Public Ip from aws management console

```
$ terraform destroy --auto-approve # To shutdown our server so we that we don't incur charges
```
## Authors

Bongani Mokase - [Email](bonganimokase@gmail.com)





