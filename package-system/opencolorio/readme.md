OpenColorIO

Built using standard build_config.json and its usual cmake scripts.

Maintainer Notes (As of OpenImageIO 3.1.15)

* We use our own version of OpenImageIO as a dependency for OpenColorIO, which avoids
  any need for it to link to or use OpenEXR.
* Unfortunately, the OpenColorIO dependency system does not take into account multi-config
  capability, so it only builds the dependencies once, with the configuration you specify. 
  This means on windows, which builds both debug and release, it has to clear the build folder
  between builds, so that debug dependendencies are not used in release builds.
* We don't build the python modules.  If we need them, we can grab them
  off pypi, rather than working with them ourselves.
* We build all dependencies statically, then link to a dynamic OpenColorIO, so it comes
  with all of the dependencies packed in and isolated.

The following third party libraries are compiled inside the binary.

* Expat 2.5.0
* yaml-cpp 0.7.0
* pystring 1.1.3
* Imath 3.1.12
* ZLIB 1.2.11 - (from O3DE)
* minizip-ng - 3.0.7
* lcms2 2.2
* OpenImageIO 3.1.15.0 (from O3DE)
