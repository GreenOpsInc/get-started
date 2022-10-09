echo "In the \"Cluster\" section of the GreenOps UI, press the \"+\" button and register a new cluster."
echo -n "Enter the Argo Workflows address:":
read argo_workflows_address
echo -n "Enter the name:":
read clustername
echo -n "Enter the generated API key:":
read -s apikey
helm install greenops-daemon ./greenops-daemon-0.1.0.tgz \
  --set 'clusterName='$clustername'' \
  --set 'greenopsApiKey='$apikey'' \
  --set 'apis.argo.workflows.url='$argo_workflows_address''
