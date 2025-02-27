#!/bin/bash
# set -e
# set -o pipefail
# # if [ "$DEBUG" = "true" ]; then
# #   set -x
# # fi

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "Error: Unable to determine the repository root. Ensure you are in a Git repository."
  exit 1
}

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

destroy_infrastructure() {
  local infra_dir="$1"
  echo "Starting destruction for: $infra_dir"
  cd "$REPO_ROOT/$infra_dir"
  
  echo "Initializing Terraform for $infra_dir..."
  terraform init -input=false || {
    echo "Error: Terraform init failed for $infra_dir"
    exit 1
  }

  echo "Destroying Terraform configuration for $infra_dir..."
  terraform destroy -auto-approve || {
    echo "Error: Terraform destroy failed for $infra_dir"
    exit 1
  }

  echo "Destruction completed for: $infra_dir"
}
for ((i=${#INFRA_ORDER[@]}-1; i>=0; i--)); do
  destroy_infrastructure "${INFRA_ORDER[i]}"
done
cd "$REPO_ROOT" || exit 1
echo "All infrastructures have been destroyed successfully!"

exec $SHELL