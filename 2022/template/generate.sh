#!/bin/bash
DIR=`dirname $0`
D=`date`
FICHIER_SED="${DIR}/Dist.sed" 
echo "s/_DEFIX/${1}/g" >> "${FICHIER_SED}"
echo "s/_FILENAME/day${1}.adb/g" >> "${FICHIER_SED}"
echo "s/_DATE/${D}/g" >> "${FICHIER_SED}"
echo "s/_PROJECTNAME/Advent of Code 2022 : ${1}/g" >> "${FICHIER_SED}"

sed -f "${FICHIER_SED}" < "${DIR}/dayX.adb" > "${DIR}/day${1}.utf8.adb"
sed -f "${FICHIER_SED}" < "${DIR}/dayX.gpr" > "${DIR}/day${1}.utf8.gpr"
rm -f "${FICHIER_SED}"

mkdir -p "${DIR}/../day${1}/src"
mkdir -p "${DIR}/../day${1}/data"
iconv -f UTF-8 -t ISO-8859-1 "${DIR}/day${1}.utf8.adb" > "${DIR}/../day${1}/src/day${1}.adb"
iconv -f UTF-8 -t ISO-8859-1 "${DIR}/day${1}.utf8.gpr" > "${DIR}/../day${1}/day${1}.gpr"

rm -f "${DIR}/day${1}.utf8.gpr" "${DIR}/day${1}.utf8.adb"
