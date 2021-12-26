# Quite OK Image WIC codec

This repository contains a *Windows Imaging Component (WIC)* for *Quite OK Image (QOI)* format.

It allows to integrate QOI files in Windows Photo Gallery and Windows Explorer.

![Windows Explorer qoi logo thumbnail](/doc/explorer_qoi_logo_thumbnail.png)

> The Quite OK Image Format for Fast, Lossless Compression. QOI is fast. It losslessy compresses images to a similar size of PNG, while offering 20x-50x faster encoding and 3x-4x faster decoding. 

> The Windows Imaging Component (WIC) provides an extensible framework for working with images and image metadata. WIC makes it possible for independent software vendors (ISVs) and independent hardware vendors (IHVs) to develop their own image codecs and get the same platform support as standard image formats (for example, TIFF, JPEG, PNG, GIF, BMP, and HDPhoto). A single, consistent set of interfaces is used for all image processing, regardless of image format, so any application using the WIC gets automatic support for new image formats as soon as the codec is installed. The extensible metadata framework makes it possible for applications to read and write their own proprietary metadata directly to image files, so the metadata never gets lost or separated from the image.  

The codec code is directly derived from René Slijkhuis' "Example WIC codec" : https://github.com/ReneSlijkhuis/example-wic-codec.

## Download

Prebuilt binaries can be downloaded from [Github Releases page](https://github.com/rotoglup/wic-codec-qoi/releases).
## Build

### Requirements
* Microsoft Windows 7 or later.
* Microsoft Visual Studio 2017 or later.
* [Inno Setup Compiler](http://www.jrsoftware.org/).

### Instructions
* Open a "Developer Command Prompt for VS2017" and change the working directory to the root of this archive.
* Run "build.bat".
* You can find the installer in the subdirectory "installer".

## Disclaimer
This codec is to be used at your own risk : proper error handling has not been added, this may cause issues when used in production environments, or security risks when used with uncontrolled inputs.

## License
Released under the [MIT license](https://en.wikipedia.org/wiki/MIT_License).
