### Terraform config для создания instance и RDS AWS. 

Для выполнения необходим файл variables.tf с следующими переменными:

aws_access_key

aws_secret_key

aws_region - регион AWS

aws_key_name - имя ssh ключа 

key - тело публичного ssh ключа для доступа 

dbname - имя БД

login - Логин БД

password - Пароль БД



Далее выполняем следующие команды:

```
terraform init
terraform apply
```
