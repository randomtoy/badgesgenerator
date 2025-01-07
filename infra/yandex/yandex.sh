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
    --create-disk name=data-disk,size=${VM_DATA_DISK_SIZE:-10},device-name=${VM_DATA_DISK_D_NAME} \
    --network-interface subnet-id=${SUBNET_ID},nat-ip-version=ipv4 \
    --service-account-id "${SERVICE_ACCOUNT_ID}" \
    --docker-compose-file ${PATH_TO_DOCKER_COMPOSE_FILE}

}

update_coi_vm() {
    yc compute instance update-container "${VM_NAME}" \
    --folder-id "${FOLDER_ID}" \
    --docker-compose-file ${PATH_TO_DOCKER_COMPOSE_FILE}
}

check_coi_vm() {
    yc compute instance get --folder-id "${FOLDER_ID}" ${VM_NAME} >/dev/null 2>&1
    echo $?
}

main(){

prepare_environment

status=$(check_coi_vm)
if [ $status -eq 1 ]; then
    install_coi_vm
else
    update_coi_vm
fi
}


main