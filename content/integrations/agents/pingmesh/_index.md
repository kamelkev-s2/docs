
---
title: Pingmesh
weight: 10
---

## Overview

Selector Pingmesh leverages distributed agents to create a "mesh" to generate traffic for measurement.

Meshes can be configured as either of the following:
* Global mesh \- All agents participate in a single global mesh  
* Pivot based mesh \- Column names in the inventory table can be used to create a mesh. Multiple columns can be used to create meshes. A single agent can participate in multiple meshes

Once configured, the following synthetic telemetry is then collected by Selector:
* Latency  
* Packet loss  
* Jitter  
* Path  
* Performance  
* Reachability

The collected telemetry can then be accessed via the Selector portal, and visualized on dashboards as a 2D grid where one axis represents the pinger and the other axis represents the ponger. Here is one such example of a pingmesh grid.  

![Pingmesh Grid Visualization](/images/agents/pingmesh/image11.png)

### Architecture

![Pingmesh Architecture](/images/agents/pingmesh/image13.png)
The monitoring service is responsible for control and coordination of the agents.The agent and the monitoring service send data in both directions. A gRPC connection initiated by the agent on TCP port 8002 allows the Monitoring service to push the configuration to each of the agents which include information on the grouping of agents, interval and size of packet generation. The agents keep sending keepalive packets and OpStats to monitoring service.

The service responsible for collection of data/metrics from the agents is called Collection Service. The connection from the agents to the collection service is a REST connection over UDP 8006 to send logs and TCP 8000 for reporting metrics

**Probe Types**

* UDP probes are used to measure latency, packet loss and jitter between S2 agents. Pingers send out probe packets and pongers listen on port 52000 for them. UDP probe source ports can be varied to take different paths starting from port 52001\.  
* Traceroute probes are used to measure path metrics for example the number of hops, change in hops etc. Both TCP and UDP probe packets are used for traceroute probes  
* Ping probes used to verify the reachability to network endpoints from an agent (ICMP)

### Agent States

An agent has two local states; Init and Registered. It would be in the Init state while trying to establish a connection to S2AP and goes into Registered state once it has established a connection to the monitoring service  
In the UI, two states of an agent can be seen; Operational and Partial. If an agent can reach all the agents in a mesh, the state is Operational. If one or more agents of a mesh are not reachable, it goes into a Partial state.

### Pingmesh Inventory

After an agent is registered with S2AP, the only attribute known of the agent is the IP address. More attributes or tags are required to assign a mesh to those agents, use them in queries or other correlations. This is where inventory comes in. The pingmesh inventory is a table of agents that contains attributes like IP address, hostname, version, status, and other meaningful attributes that help with managing the agents.

![Pingmesh Inventory](/images/agents/pingmesh/image5.png)

The PingMesh inventory can be found under Integrations\>PingMesh\>Inventory

Follow the below steps to import your import.csv file into the Pingmesh instance. For successful upload, please ensure that column headers match what is shown below. Ensure the inclusion of Lat/Long coordinates as shown below for the locations to appear on the map correctly

![Pingmesh Inventory](/images/agents/pingmesh/image15.png)

**Verifying the Successful Import of Pingmesh Inventory**  

Once the import has completed, simply click the "details" icon to review the uploaded inventory. Please ensure all data looks correct before proceeding to the next steps.!

![Pingmesh Inventory](/images/agents/pingmesh/image8.png)

### Key Features

#### MultiVRF

This is useful for a network where connectivity between switches is done via VRF aware routing in the core network. To validate the connectivity of such a network, the pingmesh agents running on the switches need to be made VRF aware so that they can source packets in the right VRFs. To be multi-VRF aware, the data plumbing inside the switches needs to look something like below. For this a single agent needs to act in multiple pinger and ponger roles.

#### Randomized Source Ports

To increase the entropy of ping probe packets, pingmesh agents generate the probe packets with random source ports. Randomization of ports increases the possibility of the probe packets traversing different paths and exercising various links in their journey to their destination.

Source ports used will be in the range 20000 to 32000\. The random source port is generated once per sweep and used for all iterations within that sweep. For the next sweep, a new port will be generated for use.

##### Technical Discussion

There are many factors to consider when exercising the paths and links within a given network.

One of the more notable constraints is the presence and impact of ARP caches. These caches, which almost always have expiry times, must be accounted for to reliably and robustly measure packet loss within the network.

Once an ARP cache entry times out, the associated cache will no longer have an entry for that specific MAC / IP Address tuple. The first probe packet received within this scenario will then be used to trigger ARP resolution and will not be forwarded to the destination as expected. ARP resolution itself is not instantaneous, and any following probe packets may themselves fail to reach the destination while the resolution cycle completes.

As a result, these initial probe packets may report a loss. In a circumstance where each sweep is configured to send a single or low number of packets, the path or link may show as down when, in fact, basic network logistics were interfering with the measurement workflow.

Otherwise, there are various other circumstances where individual packets may be discarded or lost \- especially with regard to ICMP and UDP \- where reliance on a singular packet to measure end-to-end connectivity is more likely to indicate a false positive.

To this end, Selector strongly recommends the default sweep of 10, which improves the overall veracity of the reporting to better support decision-making.

## Agent Installation

S2 agents are binaries created in Golang and are designed to be minimally resource intensive and can be deployed in 3 modes

* **Debian/rpm packages** \- The packages are hosted on the S2AP at [https://\<s2apaddress\>/debian](https://s2apaddress/debian) and [https://\<s2apaddress\>/rpm](https://s2apaddress/rpm)

* **Single-agent deployment using bash script \-** 

  s2agent\_install.sh script is used to install/uninstall/upgrade s2 agent on the host machine.

  **Install:**

  To install the s2 agent, the script takes at least two variables.

  SOURCE\_CONTROLLER \- IP address or endpoint of S2AP

  SOURCE\_INTERFACE \- Network interface of the host machine where s2agent is being installed

  SOURCE\_IPADDRESS \- IP address of the host machine where s2agent is being installed


```
SOURCE_CONTROLLER=<S2AP-ip-or-endpoint> SOURCE_INTERFACE=<network-interface-of-host> bash s2agent_install.sh install
```


  OR


```
SOURCE_CONTROLLER=<S2AP-ip-or-endpoint> SOURCE_IPADDRESS=<IPADDRESS-of-host> bash s2agent_install.sh install
```


Example : 

```
SOURCE_CONTROLLER="10.240.68.25" SOURCE_INTERFACE="ens3" bash s2agent_install.sh install SOURCE_CONTROLLER="s2m.selector.ai" SOURCE_IPADDRESS="10.240.68.81" bash s2agent_install.sh install
```

**Uninstall** :  
We can uninstall the s2 agent using the script using the following command:

```
bash s2agent_install.sh uninstall
```

**Upgrade**:  
If we need to upgrade the already installed s2 agent on the host machine, It can be done similarly to installing by just providing the "upgrade" command instead of "install."

```
SOURCE_CONTROLLER=<S2AP-ip-or-endpoint> SOURCE_INTERFACE=<network-interface-of-host> bash s2agent_install.sh upgrade
```

OR

```
SOURCE_CONTROLLER=<S2AP-ip-or-endpoint> SOURCE_IPADDRESS=<IPADDRESS-of-host> bash s2agent_install.sh upgrade
```

Example:

```
SOURCE_CONTROLLER="10.240.68.25" SOURCE_INTERFACE="ens3" bash s2agent_install.sh upgrade SOURCE_CONTROLLER="s2m.selector.ai" SOURCE_IPADDRESS="10.240.68.81" bash s2agent_install.sh upgrade
```

* **Multiple agent deployment via Ansible \-**  
  This Ansible script is for installing/uninstalling/upgrading the s2agent on Debian / RPM-based client nodes. You have two options to run this Ansible script: either using Docker or without Docker.

  ### Method 1 \--- Run the Ansible script using a Docker container

  #### Prerequisites

* OS requirement: Linux (64-bit version). Try the below command to check what version you have:

```
sudo lshw | grep -m 1  width
```

* Check the Docker version using the below command; Docker version 20.10.12 or a later version must be installed.

```
docker -v
```

* Git must be installed.  
* The client node should be Debian / RPM-based.  
* The client node private keys should be in the \~/.ssh directory.

  #### Installation

  **STEP 1:**  
  Clone the repo

	

```
git clone https://github.com/selector-ai/s2labs.git
```

Move to the Project directory

```
cd s2labs/ops/ansible/install_s2agent_linux/
```

**STEP 2:**

We need to configure the inventory file s2agent\_inventory.

```
vi playbooks/s2agent_inventory
```

##### 

**Example s2agent\_inventory file**

```
[s2agent_nodes]
10.240.68.52 ansible_ssh_private_key_file=~/.ssh/mykey ansible_ssh_common_args='-o StrictHostKeyChecking=no' ansible_user=root ansible_become=true SOURCE_INTERFACE=ens3
 
10.240.68.61 ansible_ssh_private_key_file=~/.ssh/id_rsa2 ansible_ssh_common_args='-o StrictHostKeyChecking=no' ansible_user=root ansible_become=true SOURCE_IP_V6=f8:ac:65:c1:92:bf SOURCE_INTERFACE=eth0

10.240.69.110 ansible_ssh_private_key_file=~/.ssh/id_rsa3 ansible_ssh_common_args='-o StrictHostKeyChecking=no' ansible_user=root ansible_become=true SOURCE_INTERFACE=eth0 SOURCE_IP=10.240.69.110

10.240.69.111 ansible_ssh_private_key_file=~/.ssh/id_rsa4 ansible_ssh_common_args='-o StrictHostKeyChecking=no' ansible_user=root ansible_become=true SOURCE_IP=10.240.69.78

[all:vars]
S2AP_CONTROLLER=example.selector.ai
USE_IPv6=true/false
ADD_REMOTE_DESTINATION_TO_CONF=false
REMOTE_DESTINATION_ENDPOINTS=['remote-destination.selector.ai','10.240.xx.xx']
```

\-First, define the s2agent client nodes.

\-Define the ssh key of the client node in the ansible\_ssh\_private\_key\_file variable.

\-Next, in the ansible\_user variable, define your default ssh user

\-Define ipv4 into SOURCE\_IP, ipv6 into SOURCE\_IP\_V6 and interface of client node into SOURCE\_INTERFACE variable.

\-For ipv6 You need to define both SOURCE\_INTERFACE and SOURCE\_IP\_V6 for a host.

```
10.240.68.61 ansible_ssh_private_key_file=~/.ssh/id_rsa2 ansible_ssh_common_args='-o StrictHostKeyChecking=no' ansible_user=root ansible_become=true SOURCE_IP_V6=f8:ac:65:c1:92:bf SOURCE_INTERFACE=eth0
```

\-For ipv4, You can define either SOURCE\_INTERFACE or SOURCE\_IP (If you defined both of them, then it will consider SOURCE\_IP only)

```
10.240.68.52 ansible_ssh_private_key_file=~/.ssh/mykey ansible_ssh_common_args='-o StrictHostKeyChecking=no' ansible_user=root ansible_become=true SOURCE_INTERFACE=ens3 
```

\-If the client node IPv6 address is unknown, and you prefer IPv6, set the USE\_IPv6 variable to true and define SOURCE INTERFACE. It will obtain the IPv6 address from SOURCE\_INTERFACE and utilize it in the s2 agent.

```
10.240.68.52 ansible_ssh_private_key_file=~/.ssh/mykey ansible_ssh_common_args='-o StrictHostKeyChecking=no' ansible_user=root ansible_become=true SOURCE_INTERFACE=ens3 

```

```
USE_IPv6=True
```

\-Unless otherwise provided, the value of ansible\_host will be used as the SOURCE\_IP by default.

\-Define your s2ap controller into the variable S2AP\_CONTROLLER.

\-To add multiple remote s2ap destinations in s2 agent, set the ADD\_REMOTE\_DESTINATION\_TO\_CONF variable to true and define several remote s2ap destinations in the REMOTE\_DESTINATION\_ENDPOINTS list.

```
ADD_REMOTE_DESTINATION_TO_CONF=true
```

```
REMOTE_DESTINATION_ENDPOINTS=['remote-destination.selector.ai','10.240.xx.xx']
```

\-Save and close it.

**NOTE**

If you are installing an older version of s2 agent (from before March 2022), then change the path variable S2AGENT\_CONF\_PATH to the below value.

```
vi s2agent/vars/main.yml
```

```
S2AGENT_CONF_PATH: /etc/s2agent.conf
```

---

**STEP 3:**

Build the Docker image of Ansible

```
sudo docker image build -t s2agent_ansible .
```

Run the container of Ansible

```
sudo docker container run -itd --name s2agent_ansible -v `pwd`/playbooks:/install_s2agent -v ~/.ssh:/root/.ssh  s2agent_ansible
```

**STEP 4:**

Check the reachability of client nodes before the next step.

```
sudo docker container exec -it s2agent_ansible bash -c "ansible all -i /install_s2agent/s2agent_inventory -m ping"

```

**STEP 5:**

Install/uninstall/upgrade s2 agent

**Install the s2agent:**

Run the below command to install the s2 agent on client nodes.

```
sudo docker container exec -it s2agent_ansible bash -c "ANSIBLE_DISPLAY_SKIPPED_HOSTS=false ansible-playbook -i /install_s2agent/s2agent_inventory /install_s2agent/s2agent.yaml --fork=10"

```

**To uninstall the s2 agent:**

Run the below command to uninstall the s2 agent from client nodes.

```
sudo docker container exec -it s2agent_ansible bash -c "ANSIBLE_DISPLAY_SKIPPED_HOSTS=false ansible-playbook -i /install_s2agent/s2agent_inventory /install_s2agent/s2agent.yaml -e UNINSTALL=true --fork=10"

```

**To upgrade the s2agent:**

Run the below command to upgrade s2 agent

```
sudo docker container exec -it s2agent_ansible bash -c "ANSIBLE_DISPLAY_SKIPPED_HOSTS=false ansible-playbook -i /install_s2agent/s2agent_inventory /install_s2agent/s2agent.yaml -e UPGRADE=true --fork=10"

```

**To restart the s2 agent:**

Run the below command to restart the s2 agent on client nodes.

```
sudo docker container exec -it s2agent_ansible bash -c "ANSIBLE_DISPLAY_SKIPPED_HOSTS=false ansible-playbook -i /install_s2agent/s2agent_inventory /install_s2agent/s2agent.yaml -e RESTART=true --fork=10"
```

### 

### Method 2 \--- Run the Ansible script without using a Docker container

#### Prerequisites

* OS requirement: Linux (64-bit version). Try the below command to check what version you have:

```
sudo lshw | grep -m 1  width
```


  Ansible version 2.9.6 or later must be installed. Run the command below to check.

```
ansible --version
```

  Git must be installed.

  The client nodes should be Debian / RPM-based.

  #### Installation

  **STEP 1:**

  Clone the repo

```
git clone https://github.com/selector-ai/s2labs.git

```

  **STEP 2:**

  Move to the Project directory

```
cd s2labs/ops/ansible/install_s2agent_linux/playbooks
```

  Configure the inventory file:

  We need to configure the inventory file s2agent\_inventory.

```
vi s2agent_inventory
```

  Example s2agent\_inventory file

```
[s2agent_nodes]
10.240.68.52 ansible_ssh_private_key_file=~/.ssh/mykey ansible_ssh_common_args='-o StrictHostKeyChecking=no' ansible_user=root ansible_become=true SOURCE_INTERFACE=ens3
10.240.68.61 ansible_ssh_private_key_file=~/.ssh/id_rsa2 ansible_ssh_common_args='-o StrictHostKeyChecking=no' ansible_user=root ansible_become=true SOURCE_IP=f8:ac:65:c1:92:bf
10.240.69.110 ansible_ssh_private_key_file=~/.ssh/id_rsa3 ansible_ssh_common_args='-o StrictHostKeyChecking=no' ansible_user=root ansible_become=true SOURCE_INTERFACE=eth0 SOURCE_IP=10.240.69.110



[all:vars]
S2AP_CONTROLLER=example.selector.ai
USE_IPv6=true/false
ADD_REMOTE_DESTINATION_TO_CONF=false
REMOTE_DESTINATION_ENDPOINTS=['remote-destination.selector.ai','10.240.xx.xx']
```

  \-First, define the s2agent client nodes.

  \-Define the ssh key of the client node into the ansible\_ssh\_private\_key\_file variable.

  \-Next, in the ansible\_user variable, define your default ssh user

  \-Define ipv4 into SOURCE\_IP, ipv6 into SOURCE\_IP\_V6 and interface of client node into SOURCE\_INTERFACE variable.

  \-For ipv6 You need to define both SOURCE\_INTERFACE and SOURCE\_IP\_V6 for a host.

```
10.240.68.61 ansible_ssh_private_key_file=~/.ssh/id_rsa2 ansible_ssh_common_args='-o StrictHostKeyChecking=no' ansible_user=root ansible_become=true SOURCE_IP_V6=f8:ac:65:c1:92:bf SOURCE_INTERFACE=eth0
```

  \-For ipv4 You can define either SOURCE\_INTERFACE or SOURCE\_IP (If you defined both the value of SOURCE\_IP will be used)

```
10.240.68.52 ansible_ssh_private_key_file=~/.ssh/mykey ansible_ssh_common_args='-o StrictHostKeyChecking=no' ansible_user=root ansible_become=true SOURCE_INTERFACE=ens3 
```

  \-If the client node IPv6 address is unknown, and you prefer IPv6, set the USE\_IPv6 variable to true and define SOURCE INTERFACE. It will obtain the IPv6 address from SOURCE\_INTERFACE and utilize it in s2 agent.

```
10.240.68.52 ansible_ssh_private_key_file=~/.ssh/mykey ansible_ssh_common_args='-o StrictHostKeyChecking=no' ansible_user=root ansible_become=true SOURCE_INTERFACE=ens3 

```


```
USE_IPv6=True
```

  \-Unless otherwise provided, the value of ansible\_host will be used as the SOURCE\_IP by default.

  \-Define your s2ap controller into the variable S2AP\_CONTROLLER.

  \-To add multiple remote s2ap destinations in s2agent, set the ADD\_REMOTE\_DESTINATION\_TO\_CONF variable to true and define several remote s2ap destinations in the REMOTE\_DESTINATION\_ENDPOINTS list.

```
ADD_REMOTE_DESTINATION_TO_CONF=true
```


```
REMOTE_DESTINATION_ENDPOINTS=['remote-destination.selector.ai','10.240.xx.xx']
```

  \-Save and close it.

  **NOTE**

  If you are installing an older version of s2 agent (from before March 2022), then change the path variable S2AGENT\_CONF\_PATH to below value.

```
vi s2agent/vars/main.yml
```


```
S2AGENT_CONF_PATH: /etc/s2agent.conf
```

  ---

  **STEP 3:**

  Check the reachability of client nodes before the next step.

```
ansible all -i s2agent_inventory -m ping

```

  **STEP 4:**

  Install/uninstall/upgrade s2 agent

  **Install the s2agent:**

  Run the below command to install the s2 agent on client nodes.

```
ANSIBLE_DISPLAY_SKIPPED_HOSTS=false ansible-playbook -i s2agent_inventory s2agent.yaml --fork=10

```

  **To uninstall the s2 agent:**

  Run the below command to uninstall the s2 agent from client nodes.

```
ANSIBLE_DISPLAY_SKIPPED_HOSTS=false ansible-playbook -i s2agent_inventory s2agent.yaml -e UNINSTALL=true --fork=10
```


  **To upgrade the s2agent:**

  Run the below command to upgrade s2 agent:

```
ANSIBLE_DISPLAY_SKIPPED_HOSTS=false ansible-playbook -i s2agent_inventory s2agent.yaml -e UPGRADE=true --fork=10
```

  **To restart the s2 agent:**

  Run the below command to restart the s2 agent on client nodes.

```
ANSIBLE_DISPLAY_SKIPPED_HOSTS=false ansible-playbook -i s2agent_inventory s2agent.yaml -e RESTART=true --fork=10
```

## Agent Configuration

### Required Configuration

**S2apAddr**  
Analytics platform that controls the agent

*S2apAddr   \= "s2m.selector.ai"*

**Sip**  
Agent's IPv4 source IP \- used to explicitly set the source IP. To send data packets, a source IP is required by the agent.

*Sip \= "10.0.0.1"*

**sipv6**  
Agent's IPv6 source IP \- used to explicitly set the source IP. To send data packets, a source IP is required by the agent.

*sipv6 \= "2001:7f8:4::1553:12e1"*

**SrcIntfName**  
Agent's source interface \- used to explicitly set the source interface name. Use this interface to determine the source IP. If both Sip and SrcIntfName are specified, Sip/sipv6 takes precedence.

*SrcIntfName \= "*eth0*"*

### Optional Configuration

#### Control Connection Configuration

**Cntrlsip**

Control connection's source IP

*Cntrlsip \= "localhost"*

**CntrlSrcIntfName**

Control connection's source interface

*CntrlSrcIntfName \= "eth0"*

**TLS**  
Encryption for connection to S2AP. Needs to be set to true for secure connection False by default.

*TLS \= "true"*

**S2apControlEndpoint**  
Control endpoint to register pinger

*S2apControlEndpoint   \= "s2m-mon.selector.ai"*

**S2apLogsEndpoint**  
Log endpoint to send logs

*S2apLogsEndpoint  \= "s2m.selector.ai"*

**MonitorPort**  
Port to send Monitoring data. If TLS is true, set to 443\.

*MonitorPort \= 443*

**CollectionPort**  
Port to send Collection data. If TLS is true, set to 443\.

*CollectionPort \= 443*

**S2apEndpointInsecure**  
Turn off verification of SSL certificate for endpoint submission

*S2apEndpointInsecure \= "true"*

**S2apControlEndpointInsecure**  
Turn off verification of SSL certificate for control endpoint submission

*S2apControlEndpointInsecure \= "true"*

**Debug configuration**  
Enable debug logging, default is false \- Referred to as "Debug"

*Debug  \= false*

**Multiple Ports**  
If multiple ports cannot be opened up, follow the below steps to securely talk to S2AP on port 443:

1. Enable TLS by setting it to true.By default, it is false \- Referred to as "TLS"  
2. Control endpoint to register pinger (Please check with Solutions team if any clarifications needed) \- Referred to as "S2apControlEndpoint"  
3. Log endpoint to send logs(Please check with Solutions team if any clarifications needed) \- Referred to as "S2apLogsEndpoint"  
4. Monitoring and collection service ports to be set to 443 \- Referred to as "MonitorPort" and "CollectionPort"  
5. skip-verify to be set to true for both S2AP and control endpoints \- Referred to as "S2apEndpointInsecure" and "S2apControlEndpointInsecure"

**Configuration Precedence**  
   
Control connection's source IP or source interface. To send control packets to S2AP, a source IP is required by the agent.

This source IP is optional OR can be either explicitly set OR an interface on the host can be specified whose IP will be used.

If both of them are not configured, Sip will be taken. If both of them are configured, Cntrlsip will take precedence.

**Config in GUI**

![GUI Configuration](/images/agents/pingmesh/image2.png)

**Agent config file**

![Agent Configuration](/images/agents/pingmesh/image10.png)

Items that can be removed from cfg file

| CONFIG ITEM TO BE REMOVED | REASONS |
| :--- | :--- |
| Debug \= false | Default is also false |
| DestPort \= 52000 | Default is also 52000 |
| Nports \= 1 | 1\. Overridden from GUI by “Ports per ponger”2\. Defaut is also 1 |
| PingSweepIntSec \= 15 | 1.Overridden from GUI by “Snooze Interval”2\. Default is also 15 |
| StartPort \= 52001 | 1\. Overridden from GUI by “Base Port”2\. Defaut is also 52001 |
| Qos \= "cs1" | Overridden from GUI by “TOS |
| SrcPortRandomization \= true | Default is also true |
| SnoozeIntervalSec \= 30 | Invalid config item, PingSweepIntSec is the right one |
| PktsPerIterations \= 1 | Invalid config item, NpktsPerIter is the right one |

1. Controller driven config is applicable for all the agents  
2. Controller driven config (GUI) will override that of agent config file for the respective configuration items.  
3. Only for testing purposes, we can try to override the controller driven config on a per agent basis using REST endpoint /mon/agent/pinger/config as shown below. But it's up to the discretion of the customer to use it as there are below cons that come along with this:  
1. This config will not be persisted and when agent restarts it will go back to its old config for those config items  
2. Not all the cases might have been tested here.

curl \-k \-X POST https://10.145.0.9/mon/agent/pinger/config \-d '{"address":"10.145.0.10", "config":{"pkts\_per\_iterations":1}}' , where 10.145.0.9 is S2AP address and 10.145.0.10 is the IP address of the agent.

## Pingmesh Reporting

### What are SLA Reports in Pingmesh?

Pingmesh is a comprehensive network analysis tool that utilizes ICMP and traceroute to identify changes in network performance, such as packet drops, latency, and jitter. This telemetry is generated via "Pingmesh agents," deployed throughout the network customer's infrastructure segments. The Pingmesh information is then used to calculate, display, and create alerts when set packet loss or latency thresholds are exceeded.

Generally, the information provided by the Pingmesh solution is displayed in the S2 platform's dashboard and widget system. As the solution has evolved, new reporting features have been added, allowing users to run and save Pingmesh SLA reports both manually using the S2 webgui and, in the near future, programmatically via the S2 platform's API.

### Pingmesh Reporting Workflow Diagram

![GUI Configuration](/images/agents/pingmesh/image14.png)

### Working with Pingmesh SLA Reports

Pingmesh reporting is a new feature as of 2023\. The collected Pingmesh solution data is made available for on-demand reporting via the S2 platform's web interface. Currently, reports can only be run against one Maintenance Window, one site at a time.

By default, the reports use the UTC time zone. Additionally, the default Pingmesh SLA Report runs at the beginning of each month. This report is run against each site, providing a report per site. Please note that automation support will be introduced by the end of 2023\.

### 

### Creating and Running a Pingmesh SLA Report

To create a Pingmesh SLA report, head over to the Integrations tab in the S2 webgui and click the "RestPoller" integration:

![GUI Configuration](/images/agents/pingmesh/image7.png)

Next, we select the "Reporting-SLA-Test" element from the list:

![GUI Configuration](/images/agents/pingmesh/image6.png)

From here, we define the following items to configure the report:

| Name | Setting | Function |
| :--- | :--- | :--- |
| Type | Get or Post | Defines if the poller uses Get or Post when communicating with the S2 platform. By default, Get is used. |
| URL | https://api.linx.net/network/reporting\_tool | Specifies the URL used for the report. |
| Period | 100 | Not sure |
| Attribute: Start\_time | yyyy-mm-dd hh-mm-ss | Specifies the beginning of the report time frame. |
| Attribute: Cadence | string | Defines the frequency with which the report should be run. By default, none is used. |
| Attribute: Notification\_Profile | string | Specifies which Notification Profile to use for the report; this is where the report will be sent. |
| Attribute: Date-Format | yy-mm-dd hh-mm-ss | Determines the date format used in the report. |
| Attribute: End\_Time | yyyy-mm-dd hh-mm-ss | Specifies the end of the report time frame. |
| Attribute: Network | string | Specifies which network (site) the report will be run against. |

![Agent Configuration](/images/agents/pingmesh/image4.png)

Once the Pingmesh SLA Report has been configured as required, click next to review the XML formatting of the report. Click Save Integration when finished, and the report will run at the defined time.

![Agent Configuration](/images/agents/pingmesh/image9.png)

### Pingmesh SLA Report Delivery

By default, the report is saved as a PDF and sent to the configured Notification\_Profile.

Below is an example of a Pingmesh SLA Report:  
![Agent Configuration](/images/agents/pingmesh/image12.png)

### 

### Understanding Pingmesh SLA Factors

Below is a table detailing the possible Pingmesh SLA Statuses and their definitions. Selector has come to these values through working with multiple development partners and considers them as best practice. That said, the values may be tuned with assistance from your Customer Success Engineer and/or Solutions Engineer.

|  SLA Status | Definition |
| :--- | ----- |
| Normal (green) | No dropped packets in the selected time frame  |
| Warning (orange) | One or two dropped packets in the selected time frame  |
| Alert (red) | Three or more dropped packets in the selected time frame  |
| Unknown (gray) | No packets reported dropped in the selected time frame |

### Maintenance Windows (MW) 

A "Maintenance Window" (MW) is used to define a specific timeframe or length of time during which alerts for a specific device or set of devices are suppressed. Please note that "suppressed" means the collaborative alerting component will not fire (e.g., Slack, Teams, email, and PagerDuty). Alerts that have been suppressed during a MW are still logged and available for review.

Note: *When creating a MW, the "global" option can be used to suppress all alerts for the device(s) in question. By default, the "global" option is not selected, meaning that only the specified alert will be suppressed.*

### Maintenance Window Tags (MW Tags)

There are six predefined tags that can be applied to a MW, shown below. These tags fall under two categories: tags that count against the SLA and tags that do not count against said SLA.

| MW Tag Name | Does the MW tag count against the SLA? |
| ----- | :--: |
| internal\_network\_maintenances | No |
| external\_network\_maintenances | No |
| **internal\_network\_outages** | **Yes** |
| **external\_network\_outages** | **Yes** |
| probe\_maintenances | No |
| probe\_outages | No |

# 

# Changelog

**V2.0.1**  
\-	Log cleanup

- Remove unwanted logging.  
- Refine remaining logging.

**V2.0.2**

- Bugfix: Address issue where reconfiguring an agent as an auto instance would result in that agent becoming non-functional.

**V2.0.3**

- Add command line argument to solicit agent version