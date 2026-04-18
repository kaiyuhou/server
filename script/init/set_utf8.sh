#!/bin/bash

# Set UTF-8 locale

set_utf8() {
    echo "=== Setting UTF-8 locale ==="
    cat /etc/default/locale
    sed -i 's/LANG=.*/LANG="en_US\.UTF-8"/' /etc/default/locale
    sed -i 's/LANGUAGE=.*/LANGUAGE="en_US:en"/' /etc/default/locale
    locale-gen en_US.UTF-8
    echo "New locale config:"
    cat /etc/default/locale
    echo "=== UTF-8 locale set ==="
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    set_utf8
fi
