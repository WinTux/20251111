#!/bin/bash
# Inventario dinámico en formato JSON válido para Ansible

# Obtenemos las IPs desde Terraform
IPS=$(terraform output -json ip_para_spring-boot | jq -r '.[]')

# Iniciamos el inventario JSON
echo '{'
echo '  "springboot": {'
echo '    "hosts": ['

FIRST=1
for ip in $IPS; do
  if [ $FIRST -eq 1 ]; then
    echo "      \"$ip\""
    FIRST=0
  else
    echo "    , \"$ip\""
  fi
done

echo '    ],'
echo '    "vars": {'
echo '      "ansible_user": "ubuntu",'
echo '      "ansible_ssh_private_key_file": "/Users/rusokverse/Documents/20251105/clasesdevops.pem"'
echo '    }'
echo '  }'
echo '}'
