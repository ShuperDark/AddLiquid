THEOS_PACKAGE_DIR_NAME = debs

PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AddLiquid

AddLiquid_FILES = Tweak.xm
SYSROOT = $(THEOS)/sdks/iPhoneOS11.2.sdk/
AddLiquid_CFLAGS = -fobjc-arc
AddLiquid_CCFLAGS = -std=c++14 -stdlib=libc++ -fno-rtti -fno-exceptions

ARCHS = arm64

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS)/makefiles/aggregate.mk

after-install::
	install.exec "killall -9 '-'"