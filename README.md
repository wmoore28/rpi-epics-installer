# rpi-epics-installer
Script and configuration files for running EPICS on Raspberry Pi.

NOTE: the build will take a while...

## Versions
  * EPICS_BASE 3.14.12.6
  * EPICS_HOST_ARCH linux-arm
  * SynApps 5.8 (only a subset gets compiled)
  * EPICS Extensions (currently only msi)
  * PyEpics (not currently included)

## Files
  * epicsrc - setup environmental variables
  * proxyrc - required if running at JLab
  * rpi-epics-installer.sh - installer script
  * synApps_RELEASE - release file to override default and only build a subset of apps.  Other libs required for apps that are not likely to be needed.

## Testing
```
# if needed, source one or both env configs:
$> . ./proxyrc
$> . ./epicsrc
```

Test that tools were built:
```
$> caget -h
```

It's recommended you setup your environment for future logins:
```
$> cat proxyrc >> ~/.bashrc
$> cat epicsrc >> ~/.bashrc
```

## Issues
If you find that packages missing by default or other errors arise, please submit an issue on github.

