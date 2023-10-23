# объявление переменных, которые «возвращает» root модуль 

# Чтобы предать output значения из child модулей, то мы должны их указать в root модуле следующей конструкцией module.<module_name>.<output_value_name>.

# Выводим всю информацию о vpc сетях
#output "yandex_vpc_subnets" {
#  description = "Yandex.Cloud Subnets map"
#  value       = module.yandex_vpc_subnet.yandex_vpc_subnets
#}

# Выводим private ip
#output "ip_address" {
#  description = "Private IP address"
#  value       = module.yandex_compute_instance.ip_address
#}

# Выводим public ip
#output "public_ip" {
#    description = "Public IP address"
#    value = module.yandex_compute_instance.public_ip
#}
