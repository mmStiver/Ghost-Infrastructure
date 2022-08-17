
az login
az group create --name "GhostCMSGroup" --location "japaneast"


az acr create --name "mmstiverghostacr" `
              --resource-group "GhostCMSGroup" `
              --sku "Basic" `
              --admin-enabled true `
              --location "japaneast"

az containerapp env create -n "ghostcmsenv" -g "GhostCMSGroup" `
--location "japaneast"

az containerapp create -g "GhostCMSGroup" `
--name "ghostcms" `
--environment "ghostcmsenv" `
--image "mmstiverghostacr.azurecr.io/ghost:latest" `
--registry-server "mmstiverghostacr.azurecr.io"`
--registry-username "mmstiverghostacr"`
--registry-password "jNLmhkHVzmwY8tXvIBp/yZX4m1KD7vHV"`
--cpu 0.25 --memory 0.5 `
--ingress "external" --target-port 2368


az container restart --name "ghostcms"`
                     --resource-group "GhostCMSGroup"`
                     --no-wait


az aks create -g "GhostCMSGroup" -n "ghostAKSCluster" `
  --enable-managed-identity `
  --node-count 1 `
  --enable-addons monitoring `
  --enable-msi-auth-for-monitoring  `
  --generate-ssh-keys




az container delete --name "ghostcms"`
--resource-group "GhostCMSGroup"`
    --yes