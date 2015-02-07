# -*- coding: utf-8 -*-
# Deployment settings for PokeJump.
# This file is autogenerated by the mkb system and used by the s3e deployment
# tool during the build process.

config = {}
cmdline = ['/Applications/Marmalade.app/Contents/s3e/makefile_builder/mkb.py', '/Users/Charles/Documents/Alex/ALL POKEJUMP FOLDERS/PokeJump/PokeJump/PokeJump.mkb', '--buildenv=XCODE', '--deploy-only']
mkb = '/Users/Charles/Documents/Alex/ALL POKEJUMP FOLDERS/PokeJump/PokeJump/PokeJump.mkb'
mkf = ['/Applications/Marmalade.app/Contents/s3e/s3e-default.mkf', '/Users/Charles/Documents/Alex/ALL POKEJUMP FOLDERS/PokeJump/PokeJump/PokeJump.mkf', '/Applications/Marmalade.app/Contents/juice/juice.mkf', '/Applications/Marmalade.app/Contents/juice/Components/cocotron/cocotron.mkf', '/Applications/Marmalade.app/Contents/juice/Components/libffi/libffi.mkf', '/Applications/Marmalade.app/Contents/juice/Components/libobjc2/libobjc2.mkf', '/Applications/Marmalade.app/Contents/juice/Components/libunwind/libunwind.mkf', '/Applications/Marmalade.app/Contents/modules/iwgl/iwgl.mkf', '/Applications/Marmalade.app/Contents/modules/iwutil/iwutil.mkf', '/Applications/Marmalade.app/Contents/modules/third_party/libjpeg/libjpeg.mkf', '/Applications/Marmalade.app/Contents/modules/third_party/libpng/libpng.mkf', '/Applications/Marmalade.app/Contents/modules/third_party/zlib/zlib.mkf', '/Applications/Marmalade.app/Contents/juice/Components/chameleon/chameleon.mkf', '/Applications/Marmalade.app/Contents/juice/Components/sqlite/sqlite.mkf', '/Applications/Marmalade.app/Contents/juice/Components/openssl/openssl.mkf', '/Applications/Marmalade.app/Contents/juice/Components/libopenal/libopenal.mkf', '/Applications/Marmalade.app/Contents/juice/extensions/s3eOpenAl/s3eOpenAl.mkf', '/Applications/Marmalade.app/Contents/juice/Extensions/ExtPlAndroidHelper/ExtPlAndroidHelper.mkf', '/Applications/Marmalade.app/Contents/juice/Extensions/ExtBSDSocket/ExtBSDSocket.mkf', '/Applications/Marmalade.app/Contents/juice/Extensions/ExtPosixFile/ExtPosixFile.mkf', '/Applications/Marmalade.app/Contents/juice/Extensions/s3eGCMClient/s3eGCMClient.mkf', '/Applications/Marmalade.app/Contents/juice/Extensions/s3eIME2/s3eIME2.mkf', '/Applications/Marmalade.app/Contents/juice/Extensions/s3eWebView2/s3eWebView2.mkf', '/Users/Charles/Documents/Alex/ALL POKEJUMP FOLDERS/PokeJump/PokeJump/PokeJump_arc.mkf']

class DeployConfig(object):
    pass

######### ASSET GROUPS #############

assets = {}

assets['Default'] = [
    ('/Applications/Marmalade.app/Contents/juice/Extensions/s3eWebView2/s3eWebView.js', 's3eWebView.js', 0),
]

assets['assets'] = [
    ('/Users/Charles/Documents/Alex/ALL POKEJUMP FOLDERS/PokeJump/PokeJump/data', '.', 0),
]

######### DEFAULT CONFIG #############

class DefaultConfig(DeployConfig):
    embed_icf = -1
    name = 'PokeJump'
    pub_sign_key = 0
    priv_sign_key = 0
    caption = 'PokeJump'
    long_caption = 'PokeJump'
    version = [0, 0, 1]
    config = ['/Users/Charles/Documents/Alex/ALL POKEJUMP FOLDERS/PokeJump/PokeJump/data/app.icf']
    data_dir = '/Users/Charles/Documents/Alex/ALL POKEJUMP FOLDERS/PokeJump/PokeJump/data'
    mkb_dir = '/Users/Charles/Documents/Alex/ALL POKEJUMP FOLDERS/PokeJump/PokeJump'
    iphone_link_lib = ['s3eWebView']
    osx_ext_dll = ['/Applications/Marmalade.app/Contents/juice/extensions/s3eOpenAl/lib/osx/libs3eOpenAl.dylib', '/Applications/Marmalade.app/Contents/juice/Extensions/ExtPlAndroidHelper/lib/osx/libExtPlAndroidHelper.dylib', '/Applications/Marmalade.app/Contents/juice/Extensions/ExtPlAndroidHelper/lib/osx/libExtPlAndroidHelper.dylib', '/Applications/Marmalade.app/Contents/juice/Extensions/ExtBSDSocket/lib/osx/libExtBSDSocket.dylib', '/Applications/Marmalade.app/Contents/juice/Extensions/ExtPosixFile/lib/osx/libExtPosixFile.dylib', '/Applications/Marmalade.app/Contents/juice/Extensions/ExtPosixFile/lib/osx/libExtPosixFile.dylib', '/Applications/Marmalade.app/Contents/juice/Extensions/s3eWebView2/lib/osx/libs3eWebView.dylib']
    wp81_extra_pri = []
    ws8_ext_capabilities = []
    android_external_res = []
    win32_ext_dll = ['/Applications/Marmalade.app/Contents/juice/Extensions/s3eWebView2/lib/win32/s3eWebView.dll']
    wp8_ext_capabilities = []
    ws8_extra_res = []
    ws81_ext_managed_dll = []
    iphone_link_libdir = ['/Applications/Marmalade.app/Contents/juice/Extensions/s3eWebView2/lib/iphone']
    wp81_ext_capabilities = []
    android_extra_application_manifest = []
    ws8_ext_native_dll = []
    android_external_assets = []
    blackberry_extra_descriptor = []
    android_extra_manifest = []
    wp81_ext_sdk_ref = []
    iphone_link_libdirs = []
    wp81_ext_device_capabilities = []
    linux_ext_lib = []
    ws8_ext_managed_dll = []
    ws8_ext_sdk_manifest_part = []
    ws8_ext_device_capabilities = []
    ws81_extra_pri = []
    android_external_jars = ['/Applications/Marmalade.app/Contents/juice/extensions/s3eOpenAl/lib/android/s3eOpenAl.jar', '/Applications/Marmalade.app/Contents/juice/Extensions/ExtPlAndroidHelper/lib/android/ExtPlAndroidHelper.jar', '/Applications/Marmalade.app/Contents/juice/Extensions/ExtPosixFile/lib/android/ExtPosixFile.jar', '/Applications/Marmalade.app/Contents/juice/Extensions/s3eGCMClient/lib/android/libgoogleplayservice/android-support-v4.jar', '/Applications/Marmalade.app/Contents/juice/Extensions/s3eGCMClient/lib/android/libgoogleplayservice/google-play-services.jar', '/Applications/Marmalade.app/Contents/juice/Extensions/s3eGCMClient/lib/android/s3eGCMClient.jar', '/Applications/Marmalade.app/Contents/juice/Extensions/s3eIME2/lib/android/s3eIME.jar', '/Applications/Marmalade.app/Contents/juice/Extensions/s3eWebView2/lib/android/s3eWebView.jar']
    win8_winrt_extra_res = []
    wp81_ext_sdk_manifest_part = []
    android_supports_gl_texture = []
    wp81_extra_res = []
    wp81_ext_managed_dll = []
    iphone_extra_plist = []
    ws81_ext_sdk_manifest_part = []
    ws81_ext_device_capabilities = []
    ws8_ext_sdk_ref = []
    iphone_extra_string = []
    tizen_so = []
    wp8_ext_native_dll = []
    win8_phone_extra_res = []
    win8_store_extra_res = []
    iphone_link_opts = []
    ws81_ext_sdk_ref = []
    wp8_extra_res = []
    ws81_ext_native_dll = []
    ws8_extra_pri = []
    wp8_ext_managed_dll = []
    android_extra_packages = []
    android_so = ['/Applications/Marmalade.app/Contents/juice/extensions/s3eOpenAl/lib/android/libs3eOpenAl.so', '/Applications/Marmalade.app/Contents/juice/Extensions/ExtPlAndroidHelper/lib/android/libExtPlAndroidHelper.so', '/Applications/Marmalade.app/Contents/juice/Extensions/ExtBSDSocket/lib/android/libExtBSDSocket.so', '/Applications/Marmalade.app/Contents/juice/Extensions/ExtPosixFile/lib/android/libExtPosixFile.so', '/Applications/Marmalade.app/Contents/juice/Extensions/s3eGCMClient/lib/android/libs3eGCMClient.so', '/Applications/Marmalade.app/Contents/juice/Extensions/s3eIME2/lib/android/libs3eIME.so', '/Applications/Marmalade.app/Contents/juice/Extensions/s3eWebView2/lib/android/libs3eWebView.so']
    wp8_ext_sdk_ref = []
    osx_extra_res = []
    ws81_extra_res = []
    wp81_ext_native_dll = []
    ws81_ext_capabilities = []
    iphone_link_libs = []
    target = {
         'aarch64_gcc' : {
                   'debug'   : r'/Users/Charles/Documents/Alex/ALL POKEJUMP FOLDERS/PokeJump/PokeJump/build_pokejump_xcode/build/Debug AARCH64/PokeJump.s3e',
                   'release' : r'/Users/Charles/Documents/Alex/ALL POKEJUMP FOLDERS/PokeJump/PokeJump/build_pokejump_xcode/build/Release AARCH64/PokeJump.s3e',
                 },
         'x86' : {
                   'debug'   : r'/Users/Charles/Documents/Alex/ALL POKEJUMP FOLDERS/PokeJump/PokeJump/build_pokejump_xcode/build/Debug/PokeJump.s86',
                   'release' : r'/Users/Charles/Documents/Alex/ALL POKEJUMP FOLDERS/PokeJump/PokeJump/build_pokejump_xcode/build/Release/PokeJump.s86',
                 },
         'arm_gcc' : {
                   'debug'   : r'/Users/Charles/Documents/Alex/ALL POKEJUMP FOLDERS/PokeJump/PokeJump/build_pokejump_xcode/build/Debug ARM/PokeJump.s3e',
                   'release' : r'/Users/Charles/Documents/Alex/ALL POKEJUMP FOLDERS/PokeJump/PokeJump/build_pokejump_xcode/build/Release ARM/PokeJump.s3e',
                 },
        }
    arm_arch = ''
    assets_original = assets
    assets = assets['assets']

default = DefaultConfig()
