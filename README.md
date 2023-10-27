# Репозиторий инфраструктуры <!-- omit in toc -->

В данном репозитории хранится инфраструктурная часть проекта "Пельменная".

[Momo Store](https://gitlab.praktikum-services.ru/std-018-014/momo-store)

# Оглавление <!-- omit in toc -->

- [Cтруктура репозитория](#cтруктура-репозитория)
- [Подготовка инфраструктуры](#подготовка-инфраструктуры)
  - [Кластер и хранилище](#кластер-и-хранилище)
  - [Подготовка кластера](#подготовка-кластера)
- [Установка ArgoCD](#установка-argocd)
- [Установка Grafana](#установка-grafana)
- [Установка Loki](#установка-loki)
- [Установка Prometheus](#установка-prometheus)
- [Правила версионирования](#правила-версионирования)
- [Правила внесения изменений в репозиторий](#правила-внесения-изменений-в-репозиторий)


# Cтруктура репозитория

```
.
├── chart                  - Helm чарт приложения
├── kubernetes-system      - Чарты и манифесты для дополнительных компонентов инфраструктуры
│   ├── argo
│   ├── grafana
│   ├── prometheus
│   ├── acme-issuer.yml    - Для получения сертификата в Let's Encrypt
│   ├── README.md
│   └── sa.yml
├── manifests               - манифесты для развертывания вручную (DockerCompose)
├── terraform               - манифесты IaC
├── .gitlab-ci.yml
└── README.md
```

# Подготовка инфраструктуры

## Кластер и хранилище

Заполнить файл `.s3conf`

```bash
terraform init
terraform plan -var-file secret.tfvars
terraform apply - var-file secret.tfvars
```

## Подготовка кластера

Чтобы с помощью Kubernetes создать Ingress-контроллер NGINX и защитить его сертификатом Let's Encrypt®, выполните следующие действия:

 Устанавливаем NGINX Ingress Controller

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.5.1/deploy/static/provider/cloud/deploy.yaml
```

Устанавливаем менеджер сертификатов:

```bash
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.6.1/cert-manager.yaml
```

Также нужно создайть манифест acme-issuer.yaml

```bash
kubectl apply -f acme-issuer.yaml
```
В поле mail вводим валидный адрес электронной почты. 

Манифест sa.yml необходим для создания сервисного аккуанта для последующего формирования статического конфига для доступа к кластеру, например из CI/CD

```bash
kubectl apply -f service-account.yaml
```

## Узнайтем IP-адрес Ingress-контроллера

Нам нужно значение из колонки EXTERNAL-IP:

```bash
kubectl get svc -n ingress-nginx
```
## Создадим публичную DNS запись для доступа к магазину из интернета

Для этого воспользуемся бесплатным ресурсом https://freedns.afraid.org
Регистрация на нем бесплатная, создаем DNS запись, основываясь инструкцией на сайте.
Указываем IP-адрес из предыдущего пункта и сохраним этот субдомен в качестве переменной MOMO_URL в Gitlab в настройках CI/CD
