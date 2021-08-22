**⚠️ This library is no longer maintained by myself, a newer fork is available here:** [https://github.com/AceKiron/fingerprint-gml](https://github.com/AceKiron/fingerprint-gml)

# Fingerprint GML

A simple script for fingerprinting a user in Game Maker Studio.

Inspired by: [https://github.com/Valve/fingerprintjs2](https://github.com/Valve/fingerprintjs2).

Marketplace Link: [https://marketplace.yoyogames.com/assets/6613/fingerprint](https://marketplace.yoyogames.com/assets/6613/fingerprint)

## How it works

The fingerprint is calculated by writing the following to a buffer and retrieving an MD5 hash.

- Operating system type, version and region
- Are shaders supported?
- Game specific data
- Timezone
- Language

On Windows-only, the following environment variables are used:
- Username
- Computer name
- CPU architecture, name, core count, level and revision

On Linux-only, the following environment variables are used:
- Username

## Quick start

- Import the fingerprint.gml script into your project.
- Call "get_fingerprint()" to get a fingerprint of the user.

## Requirements

* Game Maker Studio 2 (Untested in GMS1)

## Contributing

If you have ideas on how to improve the fingerprinting, either with a better hash function or by utilizing more feature detection functions in Game Maker Studio, please post an issue or submit a pull request!
