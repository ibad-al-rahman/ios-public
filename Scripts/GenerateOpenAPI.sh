#!/bin/sh

cd ./Modules/IbadPrayerTimesService
echo "yes" | swift package generate-code-from-openapi
cd -
