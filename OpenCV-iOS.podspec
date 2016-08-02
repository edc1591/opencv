Pod::Spec.new do |s|
    s.name             = 'OpenCV-iOS'
    s.version          = '3.1.1'
    s.summary          = 'OpenCV (Computer Vision) for iOS as a dynamic library.'

    s.description      = <<-DESC
OpenCV: open source computer vision library

    Homepage: http://opencv.org
    Online docs: http://docs.opencv.org
    Q&A forum: http://answers.opencv.org
    Dev zone: http://code.opencv.org
    DESC

    s.homepage         = 'https://github.com/edc1591/opencv-ios'
    s.license          = { :type => '3-clause BSD', :file => 'LICENSE' }
    s.authors          = 'opencv.org'
    s.source           = { :git => 'https://github.com/edc1591/opencv-ios.git', :tag => s.version.to_s }

    s.ios.deployment_target = "8.0"
    s.source_files = "install/include/**/*{.h,.hpp}"
    s.public_header_files = "install/include/**/*{.h,.hpp}"
    s.preserve_paths = "install"
    s.header_mappings_dir = "install/include"
    s.vendored_libraries = "install/lib/libopencv2.dylib"
    s.requires_arc = false
    s.libraries = [ 'stdc++' ]
    s.frameworks = [
        "Accelerate",
        "AssetsLibrary",
        "AVFoundation",
        "CoreGraphics",
        "CoreImage",
        "CoreMedia",
        "CoreVideo",
        "Foundation",
        "QuartzCore",
        "UIKit"
    ]

    s.prepare_command = <<-CMD
        mkdir build-iphoneos
        cd build-iphoneos
        cmake -GXcode -DBUILD_SHARED_LIBS=ON -DCMAKE_MACOSX_BUNDLE=ON -DCMAKE_XCODE_ATTRIBUTE_CODE_SIGNING_REQUIRED=NO -DAPPLE_FRAMEWORK=ON -DCMAKE_INSTALL_PREFIX=install -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=../platforms/ios/cmake/Toolchains/Toolchain-iPhoneOS_Xcode.cmake -DENABLE_NEON=ON ../
        xcodebuild -arch armv7 -arch armv7s -arch arm64 -sdk iphoneos -configuration Release -parallelizeTargets -jobs 4 ONLY_ACTIVE_ARCH=NO -target ALL_BUILD build OTHER_CFLAGS="$(inherited) -Wno-implicit-function-declaration"
        cmake -DCMAKE_INSTALL_PREFIX=install -P cmake_install.cmake
        mkdir ../build-iphonesimulator
        cd ../build-iphonesimulator
        cmake -GXcode -DBUILD_SHARED_LIBS=ON -DCMAKE_MACOSX_BUNDLE=ON -DCMAKE_XCODE_ATTRIBUTE_CODE_SIGNING_REQUIRED=NO -DAPPLE_FRAMEWORK=ON -DCMAKE_INSTALL_PREFIX=install -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=../platforms/ios/cmake/Toolchains/Toolchain-iPhoneSimulator_Xcode.cmake ../
        xcodebuild -arch x86_64 -arch i386 -sdk iphonesimulator -configuration Release -parallelizeTargets -jobs 4 ONLY_ACTIVE_ARCH=NO -target ALL_BUILD build OTHER_CFLAGS="$(inherited) -Wno-implicit-function-declaration"
        mv ../build-iphoneos/install/ ../
        cd ../install
        lipo -create lib/libopencv_world.dylib ../build-iphonesimulator/lib/Release/libopencv_world.dylib -output lib/libopencv2.dylib
        install_name_tool -id @rpath/libopencv2.dylib lib/libopencv2.dylib
    CMD
end
