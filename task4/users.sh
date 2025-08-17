#!/bin/bash
set -e

# Папка для хранения ключей и сертификатов
mkdir -p users
cd users

echo "==> Создание пользователей: developer1, dev-ops1"

USERS=("developer1" "dev-ops1")

for USER in "${USERS[@]}"; do
  echo "--> Обработка пользователя: $USER"

  openssl genrsa -out $USER.key 2048
  openssl req -new -key $USER.key -out $USER.csr -subj "//CN=$USER"
  openssl x509 -req -in $USER.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key \
    -CAcreateserial -out $USER.crt -days 365

  echo "Сертификат создан для $USER"
done

# Получение имени текущего кластера
CLUSTER_NAME=$(kubectl config view -o jsonpath='{.clusters[0].name}')

echo "==> Настройка kubeconfig"

# Добавление пользователей в kubeconfig
for USER in "${USERS[@]}"; do
  kubectl config set-credentials $USER \
    --client-certificate=$USER.crt \
    --client-key=$USER.key \
    --embed-certs=true

  kubectl config set-context $USER-context \
    --cluster=$CLUSTER_NAME \
    --user=$USER
done

echo "Все пользователи добавлены в kubeconfig"