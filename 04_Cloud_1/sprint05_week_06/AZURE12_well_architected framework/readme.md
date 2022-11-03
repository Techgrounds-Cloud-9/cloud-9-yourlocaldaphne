# [ Well Architected Framework ]
Learning about the Wel Architected Framework of Azure, pillars and the cloud services.

## Key terminology
- :\

- :\

- :\


#
## Exercise
Study:
- Well-Architected Framework van Azure
- Hoe je elke pilaar kan implementeren met cloud-diensten


#
### Sources
- 

#
### Overcome challenges
I didn't knew enough about the Well-Architected Framework yet so I did research.
#

## Results 

The Well Architected Framework is a guidance to improve the quality of a workload.

The framework is made out of 5 pillars:
- Reliability\
The ability of a system to recover from failures and continue to function.

- Security\
Protecting applications and data from threats.

- Cost Optimization\
Managing costs to maximize the value delivered.

- Operational excellence\
Operations processes that keep a system running in production.

- Performance efficiency\
The ability of a system to adapt to changes in load.

Why this framework?\
You gotta know what trade off to make to ensure the quality. You want to keep using this framework to improve as much as you can. 

Six supporting elements surrounding the Well Architected Framework:
- Azure Well-Architected Review
- Azure Advisor
- Documentation
- Partners, Support, and Services Offers
- Reference Architectures
- Design Principles

![](./../../../00_includes/AZURE12_screenshot_overview.png)
# 

It is recommended by Microsoft to use the Azure Advisor and Advisor Score to identify and prioritize ways to improve your workload.\
Both services align to the five pillar of the Well Architected Framework. 

- Azure Advisor\
Is a personalized cloud consultant that helps you follow best practices to optimize your Azure deployments. It analyzes your resource configuration and usage telemetry. It recommends solutions that can help you improve the reliability, security, cost effectiveness, performance, and operational excellence of your Azure resources.

- Advisor Score\
Is a core feature of Azure Advisor that collects Advisor recommendations into a simple, actionable score. This score enables you to tell at a glance if you're taking the necessary steps to build reliable, secure, and cost-efficient solutions, and to prioritize the actions that will yield the biggest improvement to the posture of your workloads. The Advisor score consists of an overall score, which can be further broken down into five category scores corresponding to each of the Well-Architected pillars.
#
## Reliability
A reliable workload is one that is both resilient and available.
- Resiliency is the ability of the system to recover from failures and continue to function.
- Availability is whether your users can access your workload when they need to.

For an overview of reliability principles, reference: https://learn.microsoft.com/en-us/azure/architecture/framework/resiliency/principles

#
## Security
Security follows throughout the entire lifecycle of an application; from design, implementation, deployment and operations.\
Azure provides protection against threats such as network intrusion and DDoS attacks, but you still need to build security into your applications and processes.\
Consider the following broad security areas:
- Identity management
- Protect your infrastructure
- Application security
- Data sovereignty and encryption
- Security resources
#
## Cost optimization
When you're designing a cloud solution, focus on generating incremental value early. Apply the principles of Build-Measure-Learn, to accelerate your time to market while avoiding capital-intensive solutions.\
The following topics offer cost optimization guidance as you develop the Well-Architected Framework for your workload:

- Review cost principles
- Develop a cost model
- Create budgets and alerts
- Review the cost optimization checklist

#
## Operational excellence
Operational excellence covers the operations and processes that keep an application running in production. Deployments must be reliable and predictable. Automate deployments to reduce the chance of human error. Fast and routine deployment processes won't slow down the release of new features or bug fixes. Equally important, you must quickly roll back or roll forward if an update has problems.\

The following topics provide guidance on designing and implementing DevOps practices for your Azure workload:

- Design patterns for operational excellence
- Best practices: Monitoring and diagnostics
#
## Performance efficiency
Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. The main ways to achieve performance efficiency include using scaling appropriately and implementing PaaS offerings that have scaling built in.\

The following topics offer guidance on how to design and improve the performance efficiency posture of your Azure workload:

- Design patterns for performance efficiency
- Best practices:
- Autoscaling
- Background jobs
- Caching
- CDN
- Data partitioning
