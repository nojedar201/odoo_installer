#!/bin/bash
source venv/bin/activate
read -p 'Nombre de Instancia a crear: ' instance_name
copier copy odoo/ $instance_name
docker login ghcr.io
docker-compose -f $instance_name/nginx.yaml up -d
if test -f "$instance_name/postgres.yaml"; then
    docker-compose -f $instance_name/postgres.yaml up -d
fi
docker-compose -f $instance_name/odoo.yaml up -d
sudo venv/bin/python3 $instance_name/task.py --container_name $instance_name
# detener y recargar para que cojan los cambios en nginx
docker-compose -f $instance_name/odoo.yaml down
docker-compose -f $instance_name/odoo.yaml up -d
