#!/bin/bash

set -x

[ $# -lt 3 ] && { echo "Uso: $0 <nombre-microservicio> <liquibase_command> <socket>"; exit 1; }

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

#-e "LIQUIBASE_URL=jdbc:jtds:sqlserver://172.16.0.95:1433;database=$1" \
#-e "LIQUIBASE_CONTEXTS=dev" \
liquidocker() {
    docker run --rm -v $(pwd):/liquibase/ \
    -e "LIQUIBASE_URL=jdbc:jtds:sqlserver://$4/$1" \
    -e "LIQUIBASE_USERNAME=sa" \
    -e "LIQUIBASE_PASSWORD=Password01" \
    -e "LIQUIBASE_SCHEMA=dbo" \
    -e "LIQUIBASE_DRIVER=net.sourceforge.jtds.jdbc.Driver" \
    -e "LIQUIBASE_LOGLEVEL=info" \
    -e "LIQUIBASE_CHANGELOG=$2/changelog-index.json"  \
    registry.dev.redbee.io/liquibase-mssql:latest $3
}

DIR=$1
CMD=$2
SOCKET=$3

echo "##################################################################"
echo "Ejecuto $CMD para los changelogs/changesets del directorio $DIR"
echo "##################################################################"
echo -e '\n'
asigna_base $DIR
echo "####### $CMD:"
liquidocker $BASE $DIR $CMD $SOCKET
