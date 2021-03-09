Azure Policy Samples
This repository contains built-in samples of Azure Policies that can be used as reference for creating and assigning policies to your subscriptions and resource groups. For additional samples with descriptions, see Policy samples on docs.microsoft.com.

For custom policy samples, check out our Community repo! (https://github.com/Azure/Community-Policy)

Contributing
To contribute, please submit your policies to our Community repo! (https://github.com/Azure/Community-Policy)

Reporting Samples Issues
If you discover a problem with any of the samples published here that isn't already reported in Issues, open a New issue.

Azure Policy Support
Support for Azure Policy has transitioned to standard Azure support channels so this repository will no longer be monitored for support requests. Issues opened here are only to report specific problems with the samples published in this repository. Any other issues will be closed with a pointer to this notice. Check here for information about getting support for Azure Policy.

Azure Policy Known Issues
Check here for a current list of known issues for Azure Policy.

Azure Policy Resources
Articles
Azure Policy overview
How to assign policies using the Azure portal
How to assign policies using Azure PowerShell
How to assign policies using Azure CLI
Export and manage Azure Policy resources as code with GitHub
Definition structure
Understand Policy effects
Audit VMs with Guest Configuration
Programmatically create policies
Get compliance data
Remediate non-compliant resources
References
Azure CLI
Azure PowerShell
Policy
Guest Configuration (preview)
REST API
Events
States
Assignments
Policy Definitions
Initiative Definitions
Policy Tracked Resources
Remediations
Guest Configuration (preview)
Other
Video - Build 2018
Getting Support
The general Azure Policy support role of this repository has transitioned to standard Azure support channels. See below for information about getting support help for Azure Policy.

Alias Requests
An alias enables you to restrict what values or conditions are permitted for a property on a resource. Each alias maps to the paths in different API versions for a given resource type. During policy evaluation, the policy engine gets the property path for that API version. See the documentation page on aliases here. For additional information about Azure Policy and aliases, visit this blog post.

Previously, this repository was the official channel to open requests for new aliases. Since the full set of aliases for most namespaces have now been published, support for requesting aliases is now handled by Azure Customer Support. Open a new Azure Customer Support ticket if you believe you need new aliases to be published.

This page documents the commands for discovering existing aliases.

General Questions
If you have questions you haven't been able to answer from the Azure Policy documentation, there are a few places that host discussions on Azure Policy:

Microsoft Tech Community Azure Governance conversation space
Join the Monthly Call on Azure Governance (register here)
Search old issues in this repo
Search or add to Azure Policy discussions on StackOverflow
If your questions are more in-depth or involve information that is not public, open a new Azure Customer Support ticket.

Documentation Corrections
To report issues in the Azure Policy online documentation, look for a feedback area at the bottom of the page. If you don't see a place to enter feedback, you can also directly open a new issue at the Microsoft Docs GitHub.

New built-in Policy Proposals
If you have ideas for new built-in policies you want to suggest to Microsoft, you can submit them to Azure Governance User Voice. These suggestions are actively reviewed and prioritized for implementation.

Other Support for Azure Policy
If you are encountering livesite issues or difficulties in implementing new policies that may be due to problems in Azure Policy itself, open a support ticket at Azure Customer Support. If you want to submit an idea for consideration, add an idea or upvote an existing idea at Azure Governance User Voice.

Known Issues
Azure Policy operates at a level above other Azure services by applying policy rules against PUT requests and GET responses of resource types going between Azure Resource Manager and the owning resource provider (RP). In a few cases, the behavior of a given RP is unexpected or incompatible in some way with Azure Policy. The Azure Policy team works with the RP teams to close these gaps as soon as possible after they are discovered. Usually aliases for properties of these resource types will be removed after the anomalous behavior is discovered. Issues of this nature will be documented here until final resolution.

All cases of known resource types with anomalous policy behavior are listed here. Currently there is no way to make these resource types invisible at policy authoring time, so writing policies that attempt to manage these resource types cannot be prevented, despite the fact that the results of such policies may be either incomplete or incorrect.

Resource Type query results incomplete, missing, or non-standard format
In some cases, certain RPs may return incomplete or otherwise limited or missing information about resources of a given type. The Azure Policy engine is unable to determine the compliance of any resources of such a type. Below are listed the known resource types exhibiting this problem.

Microsoft.Web/sites/siteConfig
Microsoft.Web/sites/config/* (except Microsoft.Web/sites/config/web)
Currently, there is no plan to change this behavior for the above Microsoft.Web resource types. If this scenario is important to you, please open a support ticket with the Web team.

Microsoft.HDInsights/clusters/computeProfile.roles[*].scriptActions
Microsoft.Sql/servers/auditingSettings
This type will work correctly as the related resource in AuditIfNotExists and DeployIfNotExists policies, as long as a name for the resource is provided, e.g:
          "details": {
            "type": "Microsoft.Sql/servers/auditingSettings",
            "name": "default"
          }
Microsoft.DataLakeStore/accounts
This type behaves similarly to Microsoft.Sql/servers/autidintSettings. Compliance of some fields cannot be determined except in AuditIfNotExits and DeployIfNotExists.
Microsoft.Compute/virtualMachines/instanceView
The potential for fixing these resource types is still under investigation.

Resource Type not correctly published by resource provider
In some cases, a resource provider may implement a resource type, but not correctly publish it to the Azure Resource Manager. The result of this is that Azure Policy is unable to discover the type in order to determine compliance. In some cases, this still allows deny policies to work, but compliance results will usually be incorrect. These resource types exhibit this behavior:

Microsoft.Storage/storageAccounts/blobServices
These resource types previously exhibited this behavior, but are now removed:

Microsoft.EventHub/namespaces/networkRuleSet (replaced by Microsoft.EventHub/namespaces/networkrulesets)
Microsoft.ServiceBus/namespaces/networkRuleSet (replaced by Microsoft.ServiceBus/namespaces/networkrulesets)
In some cases the unpublished resource type is actually a subtype of a published type, which causes aliases to refer to a parent type instead of the unpublished type. Evaluation of such policies fails, causing the policy to never apply to any resource.

These resource types previously exhibited this behavior but have been fixed:

Microsoft.EventHub/namespaces/networkrulesets
Microsoft.ServiceBus/namespaces/networkrulesets
Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies
Microsoft.ApiManagement/service/portalsettings/delegation
Resource management that bypasses Azure Resource Manager
Resource providers are free to implement their own resource management operations outside of Azure Resource Manager ("dataplane" operations). In almost every Azure resource type, the distinction between resource management and dataplane operations is clear and the resource provider only implements resource management one way. Occasionally, a resource provider may choose to implement a type that can be managed both ways. In this case, Azure Policy controls the standard Azure Resource Manager API normally, but operations on the direct resource provider API to create, modify and delete resources of that type bypass Azure Resource Manager so they are invisible to Azure Policy. Since policy enforcement is incomplete, we recommend that customers do not implement policies targeting such a resource type. This is the list of known such resource types:

Microsoft.Storage/storageAccounts/blobServices/containers
The storage team is working on implementing Azure Policy on its dataplane operations to address this scenario. This is expected to first be available in the middle of 2020.

Note that Azure policies for dataplane operations of certain targeted resource providers is also under active development.

Microsoft.Sql/servers/firewallRules
Firewall rules can be created/deleted/modified via T-SQL commands, which bypasses Azure Policy. There is currently no plan to address this.

Microsoft.ServiceFabric/clusters/applications
Service Fabric applications created via direct requests to the Service Fabric cluster (i.e. via New-ServiceFabricApplication) will not appear in the Azure Resource Manager representation of the Service Fabric cluster. Policy will not be able to audit/enforce these applications.

Nonstandard creation pattern
In a few instances, the creation pattern of a resource type doesn't follow normal REST patterns. In these cases, deny policies may not work or may only work for some properties. For example, certain resource types may PUT only a subset of the properties of the resource type to create the entire resource. With such types the resource could be created with a non-compliant value even though a deny policy exists to prevent it. A similar result may occur if a set of resource types can be created using a collection PUT. Known resource types that exhibit this class of behavior:

Microsoft.Sql/servers/firewallRules
Microsoft.Automation/certificates
There is currently no plan to change this behavior. If this scenario is important to you, please open a support ticket with the Azure SQL or Automation team.

Provider pass-through to non Azure Resource Manager resources
There are examples where a resource provider publishes a resource type to Azure Resource Manager, but the resources it represents cannot be managed by Azure Resource Manager. For example, Microsoft.Web has published several resource types to Azure Resource Manager that actually represent resources of the customer's site rather than Azure Resource Manager resources. Such resources cannot or should not be managed by Azure policy, and are explicitly excluded. All known examples are listed here:

Microsoft.Web/sites/deployments
Microsoft.Web/sites/functions
Microsoft.Web/sites/instances/deployments
Microsoft.Web/sites/siteextensions
Microsoft.Web/sites/slots/deployments
Microsoft.Web/sites/slots/functions
Microsoft.Web/sites/slots/instances/deployments
Microsoft.Web/sites/slots/siteextensions
Legacy or incorrect aliases
Since custom policies use aliases directly, it is usually not possible to update them without causing unintended side effects to existing custom policies. This means that aliases referring to incorrect information or following legacy naming conventions must be left in place, even though it may cause confusion. In certain cases where an alias is known to refer to the wrong information, another alias may be created as a corrected alternative to the known bad one. In these cases, the new alias will be given the name of the bad alias with .v2 appended. For example a bad alias named Microsoft.ResourceProvider/someType/someAlias would result in the addition of a corrected version named Microsoft.ResourceProvider/someType/someAlias.v2. If an alias is added to correct a .v2 alias it will be named by replacing v2 with v3. All known corrected aliases are listed here:

Microsoft.Sql/servers/databases/requestedServiceObjectiveName.v2
This project has adopted the Microsoft Open Source Code of Conduct. For more information see the Code of Conduct FAQ or contact opencode@microsoft.com with any additional questions or comments.

Optional or auto-generated resource property that bypasses policy evaluation
In a few instances, when creating a resource from Azure Portal, the property is not set in the PUT request payload. When the request reaches the resource provider, the resource provider generates the property and sets the value. Because the property is not in the request payload, the policy cannot evaluate the property. Known resource fields that exhibit this class of behavior:

Microsoft.Storage/storageAccounts/networkAcls.defaultAction
Microsoft.Authorization/roleAssignments/principalType
Microsoft.Compute/virtualMachines/storageProfile.osDisk.diskSizeGB
Microsoft.Compute/virtualMachineScaleSets/virtualMachineProfile.storageProfile.osDisk.diskSizeGB
Microsoft.Compute/virtualMachineScaleSets/virtualMachines/storageProfile.osDisk.diskSizeGB
Using this type of alias in the existence condition of auditIfNotExists or deployIfNotExists policies works correctly. These two kinds of effects will get the full resource content to evaluate the existence condition. The property is always present in GET request payloads.

Using this type of alias in audit/deny/append effect policies works partially. The compliance scan result will be correct for existing resources. However, when creating/updating the resource, there will be no audit events for audit effect policies and no deny or append behaviors for deny/append effect policies because of the missing property in the request payload.