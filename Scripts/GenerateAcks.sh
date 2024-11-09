#!/bin/sh

function release_acks {
    swift-package-list PublicSector.xcodeproj \
            --requires-license \
            --custom-file-name ReleaseSettings \
            --output-type settings-bundle \
            --output-path PublicSector/Resources/SettingsBundle
    
    cd PublicSector/Resources/SettingsBundle/ReleaseSettings.bundle
    mv en.lproj temp_en
    mv ar.lproj temp_ar
    rm -rf *.lproj
    mv temp_en en.lproj
    mv temp_ar ar.lproj
    cd -
}

function debug_acks {
    swift-package-list PublicSector.xcodeproj \
            --requires-license \
            --custom-file-name DebugSettings \
            --output-type settings-bundle \
            --output-path PublicSector/Resources/SettingsBundle

    cd PublicSector/Resources/SettingsBundle/DebugSettings.bundle
    mv en.lproj temp_en
    mv ar.lproj temp_ar
    rm -rf *.lproj
    mv temp_en en.lproj
    mv temp_ar ar.lproj
    cd -
}

export PATH="$PATH:/opt/homebrew/bin"
ln -s /opt/homebrew/bin/swift-package-list /usr/local/bin/swift-package-list

if type swift-package-list &> /dev/null; then
    echo "Generating Acknowledgements"
    release_acks
    debug_acks
else
    echo "warning: swift-package-list not installed"
    echo "run: brew tap FelixHerrmann/tap && brew install swift-package-list"
fi