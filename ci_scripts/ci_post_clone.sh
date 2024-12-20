#!/bin/sh

#  ci_post_clone.sh
#  PublicSector
#
#  Created by Hamza Jadid on 20/12/2024.
#  

# Accept macros
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES
defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES

if [[ $CI_WORKFLOW == "Deploy Release" || $CI_WORKFLOW == "Deploy Debug" ]]
then
    cd .. && agvtool new-marketing-version $(date +'%y.%m.%d')
else
    echo "Skipping post clone..."
fi
