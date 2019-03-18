#!/bin/bash

#set -x

[ $# -lt 3 ] && { echo "Uso: $0 <changelog_index_dir> <url_conexion> <liquibase_command> "; exit 1; }

# Detectamos las bases con nombres sin normalizar
asigna_base(){
  if [ $1 == 'Oauth2' ]
  then
    BASE="Security"
  else
    BASE=$1
  fi
}

liquidocker() {
    docker run --rm -v $(pwd):/liquibase/ \
    -e "LIQUIBASE_URL=jdbc:jtds:sqlserver://$3/$1" \
    -e "LIQUIBASE_USERNAME=sa" \
    -e "LIQUIBASE_PASSWORD=Password01" \
    -e "LIQUIBASE_SCHEMA=dbo" \
    -e "LIQUIBASE_DRIVER=net.sourceforge.jtds.jdbc.Driver" \
    -e "LIQUIBASE_LOGLEVEL=debug" \
    -e "LIQUIBASE_CONTEXTS=prod" \
    -e "LIQUIBASE_CHANGELOG=$2/changelog-index.json"  \
    registry.dev.redbee.io/liquibase-mssql:latest $4
}

DIR=$1
CMD=$3
SQLURL=$2


asigna_base $DIR
echo "##################################################################"
echo "Ejecuto $CMD para los changelogs/changesets la base de datos $BASE"
echo "##################################################################"
echo -e '\n'
echo "####### $CMD:"
liquidocker $BASE $DIR $SQLURL $CMD
