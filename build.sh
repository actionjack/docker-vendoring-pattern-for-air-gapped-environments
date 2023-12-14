#!/bin/bash

#change this to your ecr account
my_ecr_account="XXXXXXXXXX"

target_repo="${my_ecr_account}.dkr.ecr.eu-west-2.amazonaws.com/aws-observability/aws-for-fluent-bit"
repo_url="https://hub.docker.com/v2/repositories/amazon/aws-for-fluent-bit/tags?page_size=100"
gitsha=$(git rev-parse --short HEAD)
SCRIPTNAME=${0}

usage () {
  cat <<- EOF
  usage: $SCRIPTNAME options

  Script builds and can push the built container into ECR.
  OPTIONS:
    push-to-ecr

  Examples:
    build the ${target_repo##*/} container locally:
    $SCRIPTNAME

    build the ${target_repo##*/} container locally and push to ECR:
    $SCRIPTNAME push-to-ecr

EOF
}


get_latest_tag() {
  local response=$(curl -sSL "$repo_url")
  local tag=$(echo "$response" | jq -r '.results[].name | select(test("^[0-9]+(\\.[0-9]+)*$"))' | sort -V | tail -n1)
  echo "${tag}"
}

build_image() {
  local tag=${1}
  docker build --tag ${target_repo}:${tag}-${gitsha} -f-  . <<EOF
FROM amazon/aws-for-fluent-bit:init-${tag}
COPY config/*.conf /fluent-bit/etc/
EOF
}

login_to_ecr () {
  aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin ${my_ecr_account}.dkr.ecr.eu-west-2.amazonaws.com
}

check_container_existence() {
  local tag=${1}
  local repository_name=${target_repo#*/}
  local container_name=${tag}
  local aws_region="eu-west-2"

  local response=$(aws ecr describe-images --repository-name $repository_name --region $aws_region)

  if echo "$response" | jq -e -r ".imageDetails[].imageTags[] | select(. == \"${container_name}\")"; then
    echo "Container $container_name exists in ECR repository $repository_name"
    exit 0
  else
    echo "Container $container_name does not exist in ECR repository $repository_name"
  fi
}

docker_push () {
  local tag=${1}
  docker push ${target_repo}:${tag}
}

main () {
  ARGS=$@
  case $ARGS in
   push-to-ecr)
    local tag=$(get_latest_tag)
    login_to_ecr
    check_container_existence ${tag}-${gitsha}
    build_image ${tag}
    docker_push ${tag}-${gitsha}
    ;;
   *)
    usage
    local tag=$(get_latest_tag)
    build_image ${tag}
    ;;
  esac
}

main "$@"
