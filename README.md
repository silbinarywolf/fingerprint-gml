# Fingerprint GML

A simple script for fingerprinting a user in Game Maker Studio.
Inspired by [https://github.com/Valve/fingerprintjs2](https://github.com/Valve/fingerprintjs2).

## How it works

The fingerprint is calculated by writing the following to a buffer and retrieving an MD5 hash.

- Operating System
- Browser
- Display Width / Height
- Are Shaders Supported?
- Timezone
- Gamepad Count (+ count of connected gamepads)

## Quick start

- Import the fingerprint_md5.gml script into your project.
- Call "fingerprint_md5()" to get a fingerprint of the user.

## Requirements

* Game Maker Studio 2 (Untested in GMS1)

## Contributing

If you have ideas on how to improve the fingerprinting, either with a better hash function or by utilizing more feature detection functions in Game Maker Studio, please post an issue or submit a pull request!

Ideally this script would have better fingerprinting by being able to utilize RAM information, GPU information and CPU information such as core count / GHZ / cache sizes. Unfortunately, I haven't found any such scripts / functions in the Game Maker Studio 2 documentation.
