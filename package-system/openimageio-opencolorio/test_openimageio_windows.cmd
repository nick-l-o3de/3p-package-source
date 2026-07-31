@rem #
@rem # Copyright (c) Contributors to the Open 3D Engine Project.
@rem # For complete copyright and license terms please see the LICENSE at the root of this distribution.
@rem # 
@rem # SPDX-License-Identifier: Apache-2.0 OR MIT
@rem #
@rem #

rmdir /S /Q  temp\build_test
mkdir temp\build_test

@rem CMAKE demands forward slashes but PACKAGE_ROOT is in native path:
set "PACKAGE_ROOT=%PACKAGE_ROOT:\=/%"
set "DOWNLOADED_PACKAGE_FOLDERS=%DOWNLOADED_PACKAGE_FOLDERS:\=/%"

cmake -S test -B temp/build_test ^
    -DCMAKE_MODULE_PATH="%DOWNLOADED_PACKAGE_FOLDERS%;%PACKAGE_ROOT%" || exit /b 1

cmake --build temp/build_test --parallel --config Release || exit /b 1
cmake --build temp/build_test --parallel --config Debug || exit /b 1

@rem to run the tests, we need to create a working directory that has the necessary dll files in it:
copy temp\OpenImageIO-windows\OpenImageIO\bin\OpenImageIO.dll temp\build_test\Release\OpenImageIO.dll
copy temp\OpenImageIO-windows\OpenImageIO\bin\OpenImageIO_d.dll temp\build_test\Debug\OpenImageIO_d.dll
copy temp\OpenImageIO-windows\OpenImageIO\bin\OpenImageIO_Util.dll temp\build_test\Release\OpenImageIO_Util.dll
copy temp\OpenImageIO-windows\OpenImageIO\bin\OpenImageIO_Util_d.dll temp\build_test\Debug\OpenImageIO_Util_d.dll

pushd test
..\temp\build_test\Release\test_OpenImageIO.exe || exit /b 1
..\temp\build_test\Debug\test_OpenImageIO.exe || exit /b 1
popd

exit /b 0
