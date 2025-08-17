#!/bin/bash
set -e

echo "Применение ролей..."

kubectl apply -f roles.yml

echo "Роли добавлены"