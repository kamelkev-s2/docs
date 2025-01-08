---
title: Analytics & Insights
weight: 10
---

# Analytics and Insights {#analytics-and-insights}

Selector supports a wide variety of analytics and insights. They are enabled when required based on the use cases the customer is interested in. In addition to the insights listed and described below, the platform is very extensible and supports custom insights that can be created on a need basis. 

## Rate of Change {#rate-of-change}

This insight is intended to track the number of times the state of a specific entity such as an interface, or a BGP session, for example, changes in a specific period of time. In a network, sometimes a specific change of state is relevant, but it is also relevant to understand the frequency of those changes. 

By knowing the frequency of changes, it can be evaluated if that frequency is anomalous or not. 

Examples of use cases where this insight is used:

* Interface flaps: identify interfaces that are frequently flapping.  
* BGP session flaps: surface BGP sessions that change state frequently.  
* OSPF adjacency: identify OSPF neighborship frequently changing state.  
* ISIS adjacency: identify ISIS neighborship frequently changing state.  
* BFD session: track BFD sessions frequently changing state.  
* LDP session: surface LDP signaling instability.

## State Kept For Period of Time {#state-kept-for-period-of-time}

This insight is intended to track the time a certain entity keeps its state unchanged. This is frequently used when the state is a failing or “down” state. The fact that an entity, such as an interface, is in “down” state for a long period of time, may actually mean that this interface is not used and therefore the failing state is not such. 

This insight is used to differentiate between actual failing states or “don’t care” states that should not produce an alert. 

Examples of use cases where this insight is used:

* Interface: identify interfaces that have been down for more than 12h.  
* BGP session flaps: surface BGP sessions that have been down for more than 12h.  
* OSPF adjacency: identify OSPF neighbor down for more than 1h.  
* ISIS adjacency: identify ISIS neighbor down for more than 1h.

## Deseasonalization {#deseasonalization}

Multiple metrics in a network infrastructure are seasonal and/or are generated in different time zones (global networks). This makes it difficult to compare and cross analyze those metrics because of their variability and/or time shifts. Deseasonalizing those metrics provides a new value that is highly comparable and useful for further analysis. There are multiple ways to deseasonalize, we support: average, max, min, median. The deseasonalization may be associated with a 24h or 7 days seasonality.  

There are multiple use cases where deseasonalization is a useful technique. Some of those are:

* Compare application traffic across corporate sites in different time zones.  
* Cross-analyze number of network subscribers per pop for pops across time zones.  
* Analyze traffic packet size across network locations in different time zones.

## Delta Change {#delta-change}

Network infrastructures are dynamic systems where changes happen. Sometimes those changes are gradual and sometimes they are abrupt. Abrupt changes are usually the result of some anomalous event and it is worth detecting them. Delta change insight enables the Selector platform to identify when a specific metric changed beyond a certain threshold in a short period of time. While the platform also supports time based anomaly detection, customers frequently are interested in being alerted when a change of a specific size happens, because it may be a sign that a relevant event is happening.

Delta change is a configurable insight both in terms of the percentage change as well as the time period over which it is measured. 

Examples of use cases where this insight is applicable:

* Detects large traffic changes in interfaces or network locations.  
* Identify significant resource consumption changes, such as memory, disk.  
* Surface major network conditions (large change in number of BGP sessions down, ports down, etc.)

## Outlier Detection {#outlier-detection}

In the realm of AIOps (Artificial Intelligence for IT Operations), one of the most valuable features is the ability to detect anomalies or outliers in vast streams of data. With the complexity of today's IT environments, it's not only essential to monitor performance and system health, but also to identify and rectify deviations swiftly.

What is Outlier Detection?

Outlier detection is a sophisticated algorithmic process where unexpected data points or patterns are identified in a dataset. In the context of an AIOps tool, it allows IT teams to catch and flag unusual behavior in metrics across entities that are intended to function similarly.

Why is it Essential?

Imagine a cluster of servers, all intended to perform similarly based on their identical configurations and workloads. If one of these servers starts to behave differently, it could be a sign of several issues: an impending hardware failure, a software bug, a security breach, or other performance issues. Detecting such outliers in real-time can prevent costly downtimes, optimize performance, and ensure a smooth user experience.

Key Features and Benefits:

* Real-time Monitoring: With an AIOps tool that incorporates outlier detection, IT teams can monitor systems in real-time, ensuring that any anomaly is promptly caught and addressed.  
* Smart Notifications: Instead of getting bombarded with countless notifications, IT professionals receive alerts only when genuine outliers are detected, reducing noise and enabling faster response times.  
* Pattern Recognition: By employing advanced machine learning techniques, Selector Analytics learns from historical data. This learning ensures that the system gets better at predicting and spotting outliers as more data gets processed.  
* Enhanced Security: Outliers can sometimes indicate a security breach. Quick detection means faster response, reducing potential damage and securing the IT environment.  
* Data-Driven Decisions: With clear visibility into which entities are behaving outside of the expected norms, IT teams can make informed decisions about resource allocation, system enhancements, or necessary repairs.  
* Optimized Performance: By quickly identifying and rectifying outliers, IT infrastructures can maintain optimal performance levels, ensuring business continuity and improved user experience.

Outlier detection can be activated in any metric and fine tuned to the specific customer and use case scenarios.. 

The following are examples of use cases where outlier detection is used by Selector customers:

* ​​Detect optical transceivers that are behaving differently as they should compared to other transceivers of the same kind.  
* Identify network locations where the average packet size is significantly different and it may be a sign of a security threat.  
* Surface deviations in number of logs generated by a device of a certain type, whether it is excess of them or lack of them.  
* Detect abnormal port or BGP session flap rates that may be a symptom of a hardware or software issue.

## Hazardous Conditions {#hazardous-conditions}

Network and IT infrastructures are complex systems where multiple events happen. In a context with thousands or tens of thousands of devices, entities such as interfaces, or BGP sessions, fail frequently, just by the nature of the volume of them. Operation engineers have to deal with all those alerts, and it is very easy to miss the big picture of what is happening. Frequently, the trees will prevent them from seeing the forest.

Selector Platform, in addition to tracking the individual failures, also tracks the “big picture”, in order to identify if there is any hazardous condition that requires attention beyond the individual BGP or port failure, for example. A BGP session failing may be an event of relative importance, but the fact that a customer is “one BGP session failure away” from being completely disconnected is a different type of event of much greater severity. 

For that reason, Selector platform supports a specific type of insight called Hazcon (hazardous condition). It is a customizable insight that facilitates tracking big picture risks that otherwise may remain undetected. Whether it is BGP sessions associated with a customer, or with a region of the network. Whether it is ports associated with a peering connection or any other type of association, Selector platform can track in real time the risk associated with specific network conditions and alert accordingly, so that specific actions can be taken. 

Hazcons are activated in Selector platform configuration based on infrastructure and service requirements. 

The following are some examples of common Hazcons:

* Track % of BGP sessions down towards each remote AS number.  
* Track % of ports down towards each customer.  
* Track % of ports down towards a device.  
* Track % of BGP down towards a site.  
* Track % of tunnels down in a SD-WAN hub.

## Silent Failure Identification {#silent-failure-identification}

A software failure or a hardware failure may result in control plane issues in a network, but those failures may not be reported by the offending entity. This is what is referred to as a silent failure. The extreme case is when a device completely fails to report data or partially fails to report data. In these scenarios, the monitoring systems may not receive data about the state of entities such as BGP Sessions, or ports, etc.  This is a situation that sooner or later is detected via other mechanisms such as detecting no-data reported from that device, but they usually have longer timeouts, which will result in delayed notification of the failure. 

By correlating data across other neighboring devices, it is possible to detect the failure condition faster. If a device’s BGP process fails, very likely all BGP sessions with its neighbors will also fail. Selector platform can detect all the BGP session failures individually reported by each neighboring device, and aggregate them to identify that there is a common pattern in all of them which is the neighboring device, in this case, the one silently failing. 

Silent failure detection is an insight that can be enabled in the platform by users based on use case scenarios and outcomes required.

The following are examples of use cases where this insight is useful:

* Track % of BGP sessions down towards a peer device.  
* Track % of ports down towards a peer device.  
* Track % of ISIS or OSPF adjacencies down towards a device.  
* Track % of ports down belonging to a specific line card.  
* Track % of tunnels down in a SD-WAN hub.

## Time-based Anomaly Detection {#time-based-anomaly-detection}

In today's dynamic Network and IT landscape, Artificial Intelligence for IT Operations (AIOps) has emerged as a beacon of efficiency, transforming the way organizations manage their  infrastructures. Among the multiple features Selector Analytics offers, Time-based anomaly detection stands out as an indispensable tool for forward-looking monitoring and proactive issue resolution.

What is Time-Based Anomaly Detection?

Time-based anomaly detection is a refined algorithmic process designed to identify and flag abnormalities or deviations in data patterns over a specific time frame. Within an AIOps context, it means Selector Analytics can spot irregularities in system performance or behavior based on historical data and temporal patterns.

Why is it Essential?

Consider the routine of a typical e-commerce server that experiences traffic surges during promotional events or specific hours of the day. With time-based anomaly detection, not only are current anomalies detected, but the system can also forecast potential future anomalies based on past trends and seasonal behavior. This proactive approach allows IT and network teams to anticipate and mitigate issues before they escalate.

Key Features and Benefits:

* Predictive Insights: Leveraging historical data, Selector Analytics can provide predictions about potential future anomalies, giving teams a heads-up to prepare for any anticipated issues.  
* Customizable Time Frames: Users can adjust the time frame parameters, allowing for a tailored monitoring experience. Whether it's analyzing data on an hourly, daily, weekly, or even yearly basis, the tool provides flexibility in anomaly detection.  
* Intelligent Alarms: Alarms are triggered not just based on current anomalies but also on predicted future deviations, ensuring IT and network teams are always a step ahead in their response strategy.  
* Efficient Resource Allocation: By understanding when certain anomalies are likely to occur, resources can be allocated more effectively to ensure system stability during critical periods.  
* Historical Data Analysis: Selector Analytics continually learns from past data, refining its predictive capabilities and offering more accurate insights as more data is ingested. This includes detecting automatically the seasonality of the metrics being analyzed to properly assess when a specific value is anomalous or expected due to the hour of the day or day of the week.  
* Enhanced User Experience: By proactively addressing and rectifying potential issues, end-users benefit from a seamless and consistent IT experience, devoid of unexpected downtimes or lags.

Time based anomaly detection can be activated and fine tuned by users based on use case scenarios and outcomes.

## Trend Detection and Forecasting {#trend-detection-and-forecasting}

In the rapidly evolving sphere of Networking and IT, the ability to stay ahead and be proactive has become the keystone of operational excellence. Within the suite of capabilities that Selector Analytics presents, Trend detection and forecasting emerges as a strategic vanguard, enabling businesses to navigate the ever-shifting terrains of their IT environments.

What is Trend Detection and Forecasting?

At its core, trend detection and forecasting is an advanced analytical process that pinpoints patterns and trajectories in data over time. In the AIOps context, it goes beyond merely observing the present; it uncovers the potential directions in which system behaviors and metrics are headed, enabling actionable insights in the present, for the future.

Why is it Essential?

Imagine an enterprise that is planning a major product release or a digital campaign. Understanding past IT load trends and forecasting future demands can mean the difference between a smooth launch and an unfortunate system outage. By recognizing patterns and predicting future behaviors, IT teams can make data-driven decisions, ensuring optimal performance and system resilience.

Key Features and Benefits:

* Proactive Planning: Through precise trend detection, businesses can identify growth patterns, peak usage times, and potential bottlenecks, enabling them to proactively strategize and allocate resources.  
* Data-Driven Decisions: With a clear picture of both the present and the forecasted future, network and IT teams can make informed decisions, from infrastructure investments to maintenance schedules.  
* Automated Insights: Selector Analytics continuously analyzes data, ensuring that trends, both subtle and pronounced, are promptly recognized, eliminating the need for manual analysis.  
* Risk Mitigation: By anticipating potential system overloads or resource shortages, proactive measures can be taken to prevent costly downtimes or performance issues.  
* Continuous Learning: As more data is ingested over time, Selector Analytics refines its forecasting models, enhancing prediction accuracy and ensuring that businesses are always equipped with the latest insights.  
* Operational Excellence: By understanding and preparing for future trends, network and IT operations can be streamlined, ensuring consistent high performance, fewer disruptions, and an overall enhanced user experience.

To conclude, trend detection and forecasting in Selector Analytics is not just about observing the present but is a window into the future. By harnessing the power of AI to detect patterns and predict trajectories, businesses can navigate the complexities of their network and IT landscapes with foresight and confidence, ensuring sustained growth and operational efficiency.

Trend detection and forecasting is an insight that users can activate and fine tune to the specific use case scenarios.

## Shared Factor Analysis {#shared-factor-analysis}

A network or IT infrastructure may present multiple types of failures or events, that is a natural effect of the complexity of those systems but also of the operational and design choices made: software versions, hardware revisions, configurations, environmental conditions, etc. Multiple factors influence, in one way or another, the behavior of a network infrastructure, and sometimes, that influence is negative. 

What is Shared Factor Analysis?

While sometimes the influence of one specific factor may be very obvious and visible, frequently it is not, or it may not be just one factor, but a combination of them, that is negatively impacting the performance of the infrastructure.

Selector Analytics can identify those shared factors by analyzing all the common patterns across network failures. The result of the analysis is a set of factors and their degree of negativity \- how negative, in relative terms, their impact is. 

Why is it Essential?

Shared factor analysis uncovers compatibility issues, hardware and/or software issues, operational issues, that otherwise will remain unnoticed, and will continue impacting the performance of the network. 

By identifying which are those factor combinations, operation teams can act on them by avoiding those, thus preventing their negative influence in the network. 

Key Features and Benefits

* Proactive operation: By detecting what is driving frequent failures in the network, it is now possible to act and prevent future occurrences of those failures.  
* Continuous improvement: By continuously detecting new patterns that may negatively influence, it is possible to enable a continuous improvement process where patterns are sequentially addressed and their negative effects avoided.  
* Early detection: Networks are dynamic systems where changes are made, new software versions are introduced, new hardware deployed, etc. With Shared Factor Analysis it is possible to detect early, even when the footprint of those changes is still small, if those changes are resulting in a positive or negative impact, and act accordingly early in the process (eventually, for example, stopping deployment of a new software release if it is detected as problematic).

## Custom Insights {#custom-insights}

In the vast and varied realm of Network and IT operations, no two businesses are identical. Each possesses its unique challenges, goals, and operational nuances. Recognizing this, modern AIOps platforms like Selector Analytics must embrace the capability of generating Custom insights. This feature is more than just a standard analytical offering; it's a testament to a platform's adaptability, ensuring that AI-driven intelligence can be molded to resonate with a company's specific operational fingerprint.

What are Custom Insights?

Custom insights in Selector Analytics refer to personalized analytical findings, metrics, or data visualizations that are crafted exclusively for a particular business or customer. Leveraging the inherent flexibility and extensibility of Selector Platform, these insights are sculpted to address individual challenges, goals, and peculiarities that standard insights might overlook.

Why are they Essential?

Take an e-commerce business with seasonal sales spikes. While standard insights might highlight increased server loads, custom insights can delve deeper, analyzing patterns in relation to specific sales campaigns, regional shopping behaviors, or even site features. By focusing on what truly matters to a business, custom insights ensure that Network and IT decisions are always aligned with business objectives.

Key Features and Benefits:

* Bespoke Analysis: Custom insights offer a tailored analytical perspective, ensuring that data interpretation is always relevant and actionable for a specific business context.  
* Flexible Framework: Embracing custom insights demonstrates Selector Platform's adaptability, catering to evolving business needs and operational shifts.  
* Deeper Understanding: By focusing on what's unique to a business, custom insights provide a more profound understanding of specific challenges and opportunities.  
* Strategic Alignment: Custom insights bridge the gap between Network and IT operations and business strategy, ensuring that every analytical insight resonates with overarching business goals.  
* Enhanced User Experience: With insights tailored to specific needs, Networks and IT teams can more effectively navigate and utilize the Selector Platform, leading to swifter problem resolution and optimized operations.  
* Future-Proof Operations: As businesses evolve, so do their  Network and IT challenges. The capability for custom insights ensures that the platform remains a relevant and invaluable tool, irrespective of future shifts in business strategy or operations.

In conclusion, the ability to offer custom insights speaks volumes about Selector Platform's commitment to personalization and adaptability. By ensuring that AI-driven intelligence can be molded to fit the unique contours of each business, these platforms not only enhance the relevance of their insights but also solidify their position as indispensable allies in the quest for Network and IT operational excellence.

Custom Insights can be designed and implemented by users by partnering with customer’s technical, operation and business teams.
