# Terraform-AKS-Azure
Azure Iteration of Installation of Istio/Native Security

<h1> Reference Architecture for Code</h1>
<img src=/aks-end.png> AKS </img>

<p>Requirements (Cost that will be incurred)</p>
Microsoft Sentinel (Runs on Log Analytics)
AKS (Node size should be able to support multiple teams) - think of image size
Defender for Cloud (Containers) - Protection
Azure Key Vault (KMS) - Service would incur costs if left on as well

Open-source tools used for this
Utilizing Kiosk with the "kubectl" provider on terraform
