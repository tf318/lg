# LG webOS TV Tools

Only one tool here at the moment: a bash script to run on a rooted TV to update the recently expired LetsEncrypt CA certificates (useful for Plex or Emby setups that use LetsEncrypt certificates, since LG have not updated the CA certs on many TVs). You must have root on your TV. Once you have shell access, download this script with `curl` and run it.

## Quick Fix for CA Cert Update

On a rooted B9 or C9 just open a shell on your TV (via telnet or ssh) and run the following command:

    curl -k https://raw.githubusercontent.com/tf318/lg/main/update-ca-certs.sh | bash

That's it.

## Manual Fix for CA Cert Update

Alternatively, if you would prefer to inspect/modify the content of the script before running it, do this instead:

    cd /tmp
    curl -k https://raw.githubusercontent.com/tf318/lg/main/update-ca-certs.sh --output update-ca-certs.sh
    chmod +x update-ca-certs.sh
    ./update-ca-certs.sh

After updating the certs, the TV will reboot, and you should be good to go.

As I have no other LG devices on which to test this (filesystem layouts may be different), you may want to inspect the bash script and manually edit and run individual commands within instead, or at least use it as a guide for what to do on your own TV.
