#!/bin/bash

#set -x

[ $# -eq 0 ] && { echo "Uso: $0 nombre-microservicio"; exit 1; }

if [ $1 == 'all' -o $1 == 'ALL' ]
then
  echo "##################################################################"
  echo "Verifico todos los changelogs/changesets"
  echo "##################################################################"
  for i in $(find . -name changelog-index.json)
  do
    echo -e "\n####### DIRECTORIO: $(echo $i |awk -F \/ '{print $2}')"
    DIR=$(echo $i |awk -F\/ '{print $2}')
    docker run --rm -v $(pwd):/liquibase/ -e "LIQUIBASE_URL=jdbc:sqlserver://172.16.0.142:1433;database=$DIR" -e "LIQUIBASE_USERNAME=sa" -e "LIQUIBASE_PASSWORD=Password01" -e "LIQUIBASE_CHANGELOG=$DIR/changelog-index.json" registry.dev.redbee.io/liquibase-mssql:latest updateSQL
  done
else
  DIR=$1
  echo "##################################################################"
  echo "Verifico los changelogs/changesets del directorio $DIR"
  echo "##################################################################"
  echo -e '\n'
  docker run --rm -v $(pwd):/liquibase/ -e "LIQUIBASE_URL=jdbc:sqlserver://172.16.0.142:1433;database=$DIR" -e "LIQUIBASE_USERNAME=sa" -e "LIQUIBASE_PASSWORD=Password01" -e "LIQUIBASE_CHANGELOG=$DIR/changelog-index.json"  registry.dev.redbee.io/liquibase-mssql:latest updateSQL
fi
