OpenImageIO

Built using standard build_config.json and its usual cmake scripts.

Maintainer Notes (As of OpenImageIO 3.1.15)

* OpenImageIO has its own dependency system, and can fetch and build many of the
  libraries it depends on.  In order to avoid version conflicts, we build in isolation
  and turn OpenImageIO itself into a dynamic (shared) library, with all of its active
  dependencies packed into it as static libraries.
* Unfortunately, the OpenImageIO dependency system does not take into account multi-config
  capability, so it only builds the dependencies once, with the configuration you specify. 
  This means on windows, which builds both debug and release, it has to clear the build folder
  between builds, so that debug dependendencies are not used in release builds.
* We don't build the python modules.  If we need them, we can grab them
  off pypi, rather than working with them ourselves.
* libuhdr cannot build on windows due to a hardcoded `/Release/` directory name
  in openimageio's custom build for it, and windows builds twice, in debug and profile.

The following dependency report is captured from the windows build

## Dependencies provided by O3DE packages:
* Freetype 2.11.1
* PNG 1.6.37 
* TIFF 4.2.0.15 
* ZLIB 1.2.11 

## Dependencies fetched and built by the OpenImageIO build scripts:
* JPEG 80
* expat 2.6.3 
* fmt 12.1.0 
* GIF 5.2.1
* Imath 3.1.10 
* libjpeg-turbo 3.1.2
* minizip-ng 4.0.10 
* OpenColorIO 2.5.1 
* OpenEXR 3.3.5
* pystring 1.2.0
* Robinmap 1.4.0
* WebP 1.6.0 
* yaml-cpp 0.8.0 

## Dependencies NOT used:
* libuhdr (due to windows configuration issue)
* libjpg (alternative to libjpeg-turbo)
* OpenJPG (configuration issue)
* BZip2
* DCMTK
* FFmpeg
* JXL
* Libheif
* LibRaw
* Nuke
* OpenCV
* openjph
* Ptex
* TBB
