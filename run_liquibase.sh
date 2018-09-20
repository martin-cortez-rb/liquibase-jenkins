#!/bin/bash

set -x

[ $# -eq 0 ] && { echo "Uso: $0 <nombre-microservicio> <liquibase_command>"; exit 1; }

# Detectamos las bases con nombres sin normalizar
asigna_base(){
  if [ $1 == 'Oauth2' ]
  then
    BASE="Security"
  elif [ $1 == 'Fees' ]
  then
    BASE="Impuesto"
  else
    BASE=$1
  fi
}

liquidocker() {
    docker run --rm -v $(pwd):/liquibase/ \
    -e "LIQUIBASE_URL=jdbc:jtds:sqlserver://172.16.0.95:1433;database=$1" \
    -e "LIQUIBASE_USERNAME=sa" \
    -e "LIQUIBASE_PASSWORD=Password01" \
    -e "LIQUIBASE_SCHEMA=dbo" \
    -e "LIQUIBASE_DRIVER=net.sourceforge.jtds.jdbc.Driver" \
    -e "LIQUIBASE_LOGLEVEL=info" \
    -e "LIQUIBASE_CONTEXTS=dev" \
    -e "LIQUIBASE_CHANGELOG=$2/changelog-index.json"  \
    registry.dev.redbee.io/liquibase-mssql:latest $3
}

CMD=$2

if [ $1 == 'all' -o $1 == 'ALL' ]
then
  echo "##################################################################"
  echo "Verifico todos los changelogs/changesets"
  echo "##################################################################"
  for i in $(find . -name changelog-index.json)
  do
    echo -e "\n####### DIRECTORIO: $(echo $i |awk -F \/ '{print $2}')"
    DIR=$(echo $i |awk -F\/ '{print $2}')
    asigna_base $DIR
    echo "####### $CMD:"
    liquidocker $BASE $DIR $CMD
  done
else
  DIR=$1
  asigna_base $DIR
  echo "##################################################################"
  echo "Verifico los changelogs/changesets del directorio $DIR"
  echo "##################################################################"
  echo -e '\n'
  echo "####### $CMD:"
  liquidocker $BASE $DIR $CMD
fi
