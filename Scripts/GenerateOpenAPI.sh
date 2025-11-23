#!/bin/sh

cd ./Modules/IbadPrayerTimesRepository
echo "yes" | swift package generate-code-from-openapi
cd -
