#!/bin/bash
set -e

echo "=== 1. Проверка подключения к кластеру Kubernetes ==="
kubectl cluster-info || { echo "Ошибка: Нет подключения к Kubernetes кластеру."; exit 1; }

echo "=== 2. Создание необходимых пространств имен ==="
kubectl apply -f - <<MANIFEST
apiVersion: v1
kind: Namespace
metadata:
  name: monitoring
MANIFEST

echo "=== 3. Развертывание веб-приложения ==="
kubectl apply -f infra/app/

echo "=== 4. Настройка Gateway API (маршрутизация) ==="
kubectl apply -f infra/gateway/

echo "=== 5. Настройка мониторинга (Prometheus ServiceMonitor) ==="
kubectl apply -f infra/monitoring/

echo "=== 6. Развертывание логирования (Filebeat DaemonSet) ==="
kubectl apply -f infra/logging/filebeat-rbac.yaml

echo "=== Деплой успешно завершен! Все компоненты развернуты. ==="
