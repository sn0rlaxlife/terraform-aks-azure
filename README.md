# Terraform-AKS-Azure
Azure Iteration of Installation of Istio/Native Security

<h1> Reference Architecture for Code</h1>
<img src=/aks-end.png> AKS </img>

<p>Requirements (Cost that will be incurred)</p>
<b>Microsoft Sentinel (Runs on Log Analytics)</b>

<br>AKS (Node size should be able to support multiple teams) - think of image size</br>
<br>Defender for Cloud (Containers) - Protection</br>
<br>Azure Key Vault (KMS) - Service would incur costs if left on as well</br>

<h2>Getting Started</h2>
<b>To run the this configuration with Kiosk</b>
<br><code>az login #authenticate to your cli</code></br>
<br><code>terraform init</code></br>
<br><code>terraform apply</code></br>



<br><b>Open-source tools used for this</b></br>
Utilizing Kiosk with the "kubectl" provider on terraform

<h2>Running Conftest</h2>
<b>For conftest to work on this configuration use of conversion to json will be needed to crawl the format and select conditions</b>

<pre class="no translate">
<code>terraform init
      terraform plan -out=tfplan_2_resource
      terraform shown -json tfplan_resource | jq '.' > tfplan.json 
</code>
</pre>
