#!/bin/bash
set -e

echo "Создание связей..."

kubectl apply -f bindings.yml

echo "Роли связаны"