# Добавление пользователя в RabbitMQ и назначение ему прав

############ Параметры для правки (начало) ############
# IP или hostname
$hostname = "localhost"
# Учетная запись пользователя rabbit с правами администратора
$rabbit_admin_user = "guest"
$rabbit_admin_pass = "guest"

# Креды нового пользователя
$new_user = "test"

$user_cred = @{
    password = $new_user
    tags = 'administrator'
}

# Права пользователя
$user_permissions = @{
    configure = '.*'
    write = '.*'
    read = '.*'
}
############ Параметры для правки (конец) ############


$user_cred = (($user_cred | ConvertTo-Json) -replace '"', '\"')
$user_permissions = (($user_permissions | ConvertTo-Json) -replace '"', '\"')

# Запрашиваем инфо о пользователе
Write-Host -ForegroundColor Green "[INFO] RabbitMQ - Get info about user '$new_user'"
Write-Host "curl.exe -i -u $rabbit_admin_user`:$rabbit_admin_pass -H "content-type:application/json" -X GET http://"$hostname":15672/api/users/$new_user -silent"
$resp_get_user = curl.exe -i -u $rabbit_admin_user`:$rabbit_admin_pass -H "content-type:application/json" -X GET http://"$hostname":15672/api/users/$new_user -silent
if ($resp_get_user[0] -eq "HTTP/1.1 200 OK") {
    Write-Host "[INFO] RabbitMQ - User '$new_user' exists" -ForegroundColor Green
	return 0
} else {
    Write-Host "[INFO] RabbitMQ - User '$new_user' doesn't exist [" $resp_get_user[0] $resp_get_user[-1] "]" -ForegroundColor Yellow
}

Start-Sleep 1

# Добавляем пользователя
Write-Host -ForegroundColor Green "[INFO] RabbitMQ - Create user '$new_user'"
$resp_add_user = curl.exe -i -u $rabbit_admin_user`:$rabbit_admin_pass -H "content-type:application/json" -X PUT http://"$hostname":15672/api/users/$new_user -d $user_cred -silent
if ($resp_add_user[0] -eq "HTTP/1.1 204 No Content") {
    Write-Host "[INFO] RabbitMQ - User '$new_user' already exists" -ForegroundColor Yellow
} elseif ($resp_add_user[0] -eq "HTTP/1.1 201 Created") {
    Write-Host "[INFO] RabbitMQ - User '$new_user' created" -ForegroundColor Green
} else {
    Write-Host "[WARN] RabbitMQ - Something goes wrong [" $resp_add_user[0] "]" -ForegroundColor Red
}

Start-Sleep 1

# Добавляем права пользователю
Write-Host -ForegroundColor Green "[INFO] RabbitMQ - Set permissions to user '$new_user'"
$resp_perm = curl.exe -i -u $rabbit_admin_user`:$rabbit_admin_pass -H "content-type:application/json" -X PUT http://"$hostname":15672/api/permissions/%2f/$new_user -d $user_permissions -silent
if ($resp_perm[0] -eq "HTTP/1.1 201 Created") {
    Write-Host "[INFO] RabbitMQ - Permissions added to user '$new_user'" -ForegroundColor Green
} elseif ($resp_perm[0] -eq "HTTP/1.1 204 No Content") {
    Write-Host "[INFO] RabbitMQ - User '$new_user' already have permissions" -ForegroundColor Yellow
} else {
    Write-Host "[WARN] RabbitMQ - Something goes wrong [" $resp_perm[0] "]" -ForegroundColor Red
}
