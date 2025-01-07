#!/bin/bash
set -eu

prepare_environment() {

    echo "$SSH_PUB_KEY" > ./key.pub

}

install_coi_vm() {

    yc compute instance create-with-container   \
    --folder-id "${FOLDER_ID}" \
    --name "${VM_NAME}" --zone "${VM_ZONE}" --ssh-key ./key.pub \
    --cores ${VM_CORE:-2} --memory ${MEMORY_SIZE:-2} \
    --create-boot-disk size=${VM_BOOT_DISK_SIZE:-30} \
    --create-disk name=${VM_DATA_DISK_D_NAME},size=${VM_DATA_DISK_SIZE:-10},device-name=${VM_DATA_DISK_D_NAME} \
    --network-interface subnet-id=${SUBNET_ID},nat-ip-version=ipv4 \
    --service-account-id "${SERVICE_ACCOUNT_ID}" \
    --docker-compose-file ${PATH_TO_DOCKER_COMPOSE_FILE} \
    >/dev/null 2>&1
    echo $?

}

update_coi_vm() {
    yc compute instance update-container "${VM_NAME}" \
    --folder-id "${FOLDER_ID}" \
    --docker-compose-file ${PATH_TO_DOCKER_COMPOSE_FILE} \
    >/dev/null 2>&1
    echo $?
}

check_coi_vm() {
    yc compute instance get --folder-id "${FOLDER_ID}" ${VM_NAME} >/dev/null 2>&1
    echo $?
}


prepare_docker_compose() {
    sed -e "s/{{VM_DATA_DISK_D_NAME}}/${VM_DATA_DISK_D_NAME}/" \
    infra/yandex/docker-compose-yandex.yml.example > infra/yandex/docker-compose-yandex.yml
}

main() {

prepare_environment
prepare_docker_compose

status=$(check_coi_vm)
if [ $status -eq 1 ]; then
    done=$(install_coi_vm)
else
    done=$(update_coi_vm)
fi

if [ $done -eq 1 ]; then
    echo "Deploy completed with error"
    exit 1
fi


}


main