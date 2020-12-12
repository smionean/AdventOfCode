#!/bin/bash
DIR=`dirname $0`

FICHIER_SED="${DIR}/Dist.sed" 
echo "s/_DEFIX/${1}/g" >> "${FICHIER_SED}"
sed -f "${FICHIER_SED}" < "${DIR}/advent-dayX.adb" > "${DIR}/../advent-day${1}.utf8.adb"
sed -f "${FICHIER_SED}" < "${DIR}/advent-dayX.ads" > "${DIR}/../advent-day${1}.utf8.ads"
rm -f "${FICHIER_SED}"

iconv -f UTF-8 -t ISO-8859-1 "${DIR}/../advent-day${1}.utf8.adb" > "${DIR}/../advent-day${1}.adb"
iconv -f UTF-8 -t ISO-8859-1 "${DIR}/../advent-day${1}.utf8.ads" > "${DIR}/../advent-day${1}.ads"

rm -f "${DIR}/../advent-day${1}.utf8.ads" "${DIR}/../advent-day${1}.utf8.adb"

