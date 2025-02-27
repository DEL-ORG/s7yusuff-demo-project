#!/bin/bash

# set -e
# set -o pipefail

# if [ "$DEBUG" = "true" ]; then
#   set -x
# fi

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

declare -a INFRA_ORDER=(
  #"resources/dev/s3-backend"
  #"resources/dev/vpc"
  #"resources/dev/sg"
  #"resources/dev/secret-manager"
  #"resources/dev/jump-server"
  #"resources/dev/sm-retrieval"
  #"resources/prod/iam"
  #/resources/dev/rds"
  "resources/alb"
  "resources/records"
  "resources/EKS-control-plane"
  "resources/nodegroup-eks"
  "resources/auth-config"
  "resources/argocd"
 
  
  

)

provision_infrastructure() {
  local infra_dir="$1"

  cd "$REPO_ROOT/$infra_dir" || {
    echo "Error: Unable to access directory $REPO_ROOT/$infra_dir"
    exit 1
  }
  terraform init -input=false || {
    echo "Error: Terraform init failed for $infra_dir"
    exit 1
  }
  terraform fmt || {
    echo "Error: Terraform fmt failed for $infra_dir"
    exit 1
  }
  terraform apply -auto-approve || {
    echo "Error: Terraform apply failed for $infra_dir"
    exit 1
  }
  echo "Provisioning completed for: $infra_dir"
}
for infra in "${INFRA_ORDER[@]}"; do
  provision_infrastructure "$infra"
done

cd "$REPO_ROOT" || exit 1
echo "All infrastructures have been provisioned successfully!"

read -p "Press Enter to exit..."
exec $SHELL
