#!/bin/bash
set -eu

prepare_environment() {

    echo "$SSH_PUB_KEY" > ./key.pub
    echo "$SSH_PRIVATE_KEY" >./key.private

}

install_coi_vm() {
    echo "Installing COI"

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
    echo "Updating COI"

    yc compute instance update-container "${VM_NAME}" \
    --folder-id "${FOLDER_ID}" \
    --docker-compose-file ${PATH_TO_DOCKER_COMPOSE_FILE} \
    >/dev/null 2>&1
    echo $?
}

prepare_ansible() {
    apt install -y ansible jq
    echo $?
}

trigger_ansible_install() {
    prepare_nginx_config

    local address=$(get_coi_ip_address)
    prepare_hosts_config $address

    ansible-playbook -i infra/yandex/ansible infra/yandex/ansible/playbook.yml

}

check_coi_vm() {
    yc compute instance get --folder-id "${FOLDER_ID}" ${VM_NAME} >/dev/null 2>&1
    echo $?
}

get_coi_ip_address() {
    echo $(yc compute instance get --folder-id "${FOLDER_ID}" ${VM_NAME} --format=json | jq '.network_interfaces[0].primary_v4_address.one_to_one_nat.address' | sed -e "s/\"//g")
}

prepare_docker_compose() {
    sed -e "s/{{VM_DATA_DISK_D_NAME}}/${VM_DATA_DISK_D_NAME}/" \
    infra/yandex/docker-compose-yandex.yml.example > infra/yandex/docker-compose-yandex.yml
}

prepare_nginx_config() {
    sed -e "s/{{SITE_ADDRESS}}/${SITE_ADDRESS}/" \
    infra/yandex/ansible/files/nginx.conf.example > infra/yandex/ansible/files/nginx.conf
}

prepare_hosts_config() {
    sed -e "s/{{SITE_ADDRESS}}/${1}/" \
    infra/yandex/ansible/inventory/hosts.example > infra/yandex/ansible/inventory/hosts
}

main() {

prepare_environment
prepare_docker_compose

status=$(check_coi_vm)
if [ $status -eq 1 ]; then
    install_coi_vm
    prepare_ansible
    trigger_ansible_install
else
    update_coi_vm
fi

}


main