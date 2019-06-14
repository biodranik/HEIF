# HEIF
Mac OS X: Convert any image to HEIF/HEIC format

Usage: ```HEIF [-q=quality] <image>```
where quality is in range from 0.1 (max compression) to 1.0 (lossless), default is 0.76

Compiling on macOS (to create executable `HEIF` and copying to `bin` folder):

    cd HEIF
    swiftc -o HEIF main.swift
    cp HEIF /usr/local/bin

Or simply run from terminal without compilation:

    ./main.swift <image>
