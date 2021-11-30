#!/bin/bash
DIR=`dirname $0`

FICHIER_SED="${DIR}/Dist.sed" 
echo "s/_DEFIX/${1}/g" >> "${FICHIER_SED}"
sed -f "${FICHIER_SED}" < "${DIR}/dayX.adb" > "${DIR}/day${1}.utf8.adb"
sed -f "${FICHIER_SED}" < "${DIR}/dayX.gpr" > "${DIR}/day${1}.utf8.gpr"
rm -f "${FICHIER_SED}"

mkdir -p "../day${1}/src"
mkdir -p "../day${1}/data"
iconv -f UTF-8 -t ISO-8859-1 "${DIR}/day${1}.utf8.adb" > "${DIR}/../day${1}/src/day${1}.adb"
iconv -f UTF-8 -t ISO-8859-1 "${DIR}/day${1}.utf8.gpr" > "${DIR}/../day${1}/day${1}.gpr"

rm -f "${DIR}/day${1}.utf8.gpr" "${DIR}/day${1}.utf8.adb"

