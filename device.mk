target_arch := $(strip $(shell cat result/arm_arch))
# $(warning target_arch: $(target_arch))

# secure
is_secure := $(shell cat kernel/.config | grep -q "CONFIG_SUPPORT_OPTEE_OS=y" && echo -n 1 || echo -n 0)

################################################################################
# kernel
################################################################################
kernel_patch_level := $(shell cat kernel/Makefile | grep "PATCHLEVEL =" | cut -f 3 -d ' ')
# $(warning kernel_patch_level: $(kernel_patch_level))
kernel_image :=
ifeq ($(strip $(target_arch)),32)
ifeq ($(strip $(kernel_patch_level)),4)
kernel_image := uImage
endif
ifeq ($(strip $(kernel_patch_level)),18)
kernel_image := zImage
endif
endif
ifeq ($(strip $(target_arch)),64)
kernel_image := Image
endif
# $(warning kernel_image: $(kernel_image))
PRODUCT_COPY_FILES += \
	kernel/arch/arm/boot/$(kernel_image):kernel

################################################################################
# bootloader
################################################################################
PRODUCT_COPY_FILES += \
	u-boot/u-boot.bin:bootloader

################################################################################
# 2ndboot
################################################################################
PRODUCT_COPY_FILES += \
	device/nexell/s5p6818_general/boot/2ndboot.bin:2ndbootloader

################################################################################
# init
################################################################################
ifeq ($(strip $(target_arch)),32)
PRODUCT_COPY_FILES += \
	device/nexell/s5p6818_general/init.s5p6818_general.rc:root/init.s5p6818_general.rc \
	device/nexell/s5p6818_general/init.s5p6818_general.usb.rc:root/init.s5p6818_general.usb.rc \
	device/nexell/s5p6818_general/ueventd.s5p6818_general.rc:root/ueventd.s5p6818_general.rc \
	device/nexell/s5p6818_general/init.recovery.s5p6818_general.rc:root/init.recovery.s5p6818_general.rc
endif

ifeq ($(strip $(kernel_patch_level)),18)
PRODUCT_COPY_FILES += \
	device/nexell/s5p6818_general/fstab.s5p6818_general64:root/fstab.s5p6818_general
else
PRODUCT_COPY_FILES += \
	device/nexell/s5p6818_general/fstab.s5p6818_general:root/fstab.s5p6818_general
endif

ifeq ($(strip $(target_arch)),64)
PRODUCT_COPY_FILES += \
	device/nexell/s5p6818_general/init.s5p6818_general64.rc:root/init.s5p6818_general64.rc \
	device/nexell/s5p6818_general/init.s5p6818_general.usb.rc:root/init.s5p6818_general64.usb.rc \
	device/nexell/s5p6818_general/fstab.s5p6818_general64:root/fstab.s5p6818_general64 \
	device/nexell/s5p6818_general/ueventd.s5p6818_general.rc:root/ueventd.s5p6818_general64.rc \
	device/nexell/s5p6818_general/init.recovery.s5p6818_general.rc:root/init.recovery.s5p6818_general64.rc
endif

PRODUCT_COPY_FILES += \
	device/nexell/s5p6818_general/adj_lowmem.sh:root/adj_lowmem.sh \
	device/nexell/s5p6818_general/bootanimation.zip:system/media/bootanimation.zip

################################################################################
# recovery
################################################################################
PRODUCT_COPY_FILES += \
	device/nexell/s5p6818_general/busybox:busybox

################################################################################
# key
################################################################################
PRODUCT_COPY_FILES += \
	device/nexell/s5p6818_general/keypad_s5p6818_general.kl:system/usr/keylayout/keypad_s5p6818_general.kl \
	device/nexell/s5p6818_general/keypad_s5p6818_general.kcm:system/usr/keychars/keypad_s5p6818_general.kcm

################################################################################
# touch
################################################################################
PRODUCT_COPY_FILES += \
    device/nexell/s5p6818_general/tsc2007.idc:system/usr/idc/tsc2007.idc

################################################################################
# camera
################################################################################
PRODUCT_PACKAGES += \
	camera.slsiap

################################################################################
# hwc executable
################################################################################
PRODUCT_PACKAGES += \
    report_hwc_scenario

################################################################################
# sensor
################################################################################
PRODUCT_PACKAGES += \
	sensors.s5p6818_general

PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:system/etc/media_codecs_google_video.xml

################################################################################
# audio
################################################################################
# mixer paths
PRODUCT_COPY_FILES += \
	device/nexell/s5p6818_general/audio/tiny_hw.s5p6818_general.xml:system/etc/tiny_hw.s5p6818_general.xml
# audio policy configuration
PRODUCT_COPY_FILES += \
	device/nexell/s5p6818_general/audio/audio_policy.conf:system/etc/audio_policy.conf

################################################################################
# media, camera
################################################################################
PRODUCT_COPY_FILES += \
	device/nexell/s5p6818_general/media_codecs.xml:system/etc/media_codecs.xml \
	device/nexell/s5p6818_general/media_profiles.xml:system/etc/media_profiles.xml

################################################################################
# modules 
################################################################################
# ogl
ifeq ($(strip $(kernel_patch_level)),4)
PRODUCT_COPY_FILES += \
	hardware/samsung_slsi/slsiap/prebuilt/library/libVR.so:system/lib/libVR.so \
	hardware/samsung_slsi/slsiap/prebuilt/library/libEGL_vr.so:system/lib/egl/libEGL_vr.so \
	hardware/samsung_slsi/slsiap/prebuilt/library/libGLESv1_CM_vr.so:system/lib/egl/libGLESv1_CM_vr.so \
	hardware/samsung_slsi/slsiap/prebuilt/library/libGLESv2_vr.so:system/lib/egl/libGLESv2_vr.so

PRODUCT_COPY_FILES += \
	hardware/samsung_slsi/slsiap/prebuilt/modules/vr.ko:system/lib/modules/vr.ko
endif

ifeq ($(strip $(kernel_patch_level)),18)
PRODUCT_COPY_FILES += \
	hardware/samsung_slsi/slsiap/prebuilt/library/libGLES_mali.so.32:system/lib/egl/libGLES_mali.so \
	hardware/samsung_slsi/slsiap/prebuilt/library/libGLES_mali.so.64:system/lib64/egl/libGLES_mali.so

PRODUCT_COPY_FILES += \
	hardware/samsung_slsi/slsiap/prebuilt/modules/mali.ko:system/lib/modules/mali.ko
endif

# coda
ifeq ($(strip $(kernel_patch_level)),4)
PRODUCT_COPY_FILES += \
	hardware/samsung_slsi/slsiap/prebuilt/modules/nx_vpu.ko:system/lib/modules/nx_vpu.ko
endif

# optee
ifeq ($(strip $(is_secure)),1)
PRODUCT_COPY_FILES += \
	linux/secureos/optee_os_3.18/optee.ko:system/lib/modules/optee.ko \
	linux/secureos/optee_os_3.18/optee_armtz.ko:system/lib/modules/optee_armtz.ko
endif

# ffmpeg libraries
EN_FFMPEG_EXTRACTOR := true
EN_FFMPEG_AUDIO_DEC := true
ifeq ($(EN_FFMPEG_EXTRACTOR),true)
PRODUCT_COPY_FILES += \
	hardware/samsung_slsi/slsiap/omx/codec/ffmpeg/libs/libavcodec-2.1.4.so:system/lib/libavcodec-2.1.4.so    \
	hardware/samsung_slsi/slsiap/omx/codec/ffmpeg/libs/libavdevice-2.1.4.so:system/lib/libavdevice-2.1.4.so  \
	hardware/samsung_slsi/slsiap/omx/codec/ffmpeg/libs/libavfilter-2.1.4.so:system/lib/libavfilter-2.1.4.so  \
	hardware/samsung_slsi/slsiap/omx/codec/ffmpeg/libs/libavformat-2.1.4.so:system/lib/libavformat-2.1.4.so  \
	hardware/samsung_slsi/slsiap/omx/codec/ffmpeg/libs/libavresample-2.1.4.so:system/lib/libavresample-2.1.4.so \
	hardware/samsung_slsi/slsiap/omx/codec/ffmpeg/libs/libavutil-2.1.4.so:system/lib/libavutil-2.1.4.so      \
	hardware/samsung_slsi/slsiap/omx/codec/ffmpeg/libs/libswresample-2.1.4.so:system/lib/libswresample-2.1.4.so \
	hardware/samsung_slsi/slsiap/omx/codec/ffmpeg/libs/libswscale-2.1.4.so:system/lib/libswscale-2.1.4.so
endif

# Nexell Dual Audio
EN_DUAL_AUDIO := false
ifeq ($(EN_DUAL_AUDIO),true)
	PRODUCT_COPY_FILES += \
	  	hardware/samsung_slsi/slsiap/prebuilt/libnxdualaudio/lib/libnxdualaudio.so:system/lib/libnxdualaudio.so
endif

# wifi

PRODUCT_COPY_FILES += \
    hardware/samsung_slsi/slsiap/prebuilt/modules/wlan.ko:/system/lib/modules/wlan.ko

################################################################################
# generic
################################################################################
#PRODUCT_COPY_FILES += \
  #device/nexell/s5p6818_general/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml \
  #frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
  #frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
  #frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
  #frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
  #frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
  #frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
  #frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
  #frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
  #frameworks/native/data/etc/android.hardware.audio.low_latency.xml:system/etc/permissions/android.hardware.audio.low_latency.xml \
  #linux/slsiap/library/lib/ratecontrol/libnxvidrc_android.so:system/lib/libnxvidrc_android.so

#PRODUCT_COPY_FILES += \
    #frameworks/native/data/etc/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml \
    #frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    #frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    #frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    #frameworks/native/data/etc/android.hardware.camera.xml:system/etc/permissions/android.hardware.camera.xml \
    #frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    #frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    #frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    #frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    #frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    #frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    #frameworks/native/data/etc/android.hardware.sensor.barometer.xml:system/etc/permissions/android.hardware.sensor.barometer.xml \
    #frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    #frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    #frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    #frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:system/etc/permissions/android.hardware.sensor.stepcounter.xml \
    #frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:system/etc/permissions/android.hardware.sensor.stepdetector.xml \
    #frameworks/native/data/etc/android.hardware.audio.low_latency.xml:system/etc/permissions/android.hardware.audio.low_latency.xml \
    #frameworks/native/data/etc/android.hardware.nfc.xml:system/etc/permissions/android.hardware.nfc.xml \
    #frameworks/native/data/etc/android.hardware.nfc.hce.xml:system/etc/permissions/android.hardware.nfc.hce.xml \
    #frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    #frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
    #frameworks/native/data/etc/android.hardware.opengles.aep.xml:system/etc/permissions/android.hardware.opengles.aep.xml \
    #frameworks/native/data/etc/android.hardware.ethernet.xml:system/etc/permissions/android.hardware.ethernet.xml

PRODUCT_COPY_FILES += \
	device/nexell/s5p6818_general/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.camera.xml:system/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:system/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:system/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:system/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:system/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:system/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.ethernet.xml:system/etc/permissions/android.hardware.ethernet.xml

ifeq ($(strip $(target_arch)),32)
PRODUCT_COPY_FILES += \
	linux/platform/s5p6818/library/lib/libnxvidrc_android.so:system/lib/libnxvidrc_android.so
endif

PRODUCT_COPY_FILES += \
	device/nexell/s5p6818_general/busybox:system/bin/busybox \
	device/nexell/s5p6818_general/memtester1-1:system/bin/memtester1-1 \
	device/nexell/s5p6818_general/hwreg_cmd:system/bin/hwreg_cmd

PRODUCT_AAPT_CONFIG := normal large xlarge hdpi xhdpi xxhdpi
#PRODUCT_AAPT_PREF_CONFIG := hdpi
PRODUCT_AAPT_PREF_CONFIG := xhdpi

# 4330 delete nosdcard
# PRODUCT_CHARACTERISTICS := tablet,nosdcard
# PRODUCT_CHARACTERISTICS := tablet,usbstorage
PRODUCT_CHARACTERISTICS := tablet

DEVICE_PACKAGE_OVERLAYS := \
	device/nexell/s5p6818_general/overlay

PRODUCT_TAGS += dalvik.gc.type-precise

PRODUCT_PACKAGES += \
    libwpa_client \
    hostapd \
    wpa_supplicant \
    wpa_supplicant.conf

PRODUCT_PACKAGES += \
	LiveWallpapersPicker \
	librs_jni \
	com.android.future.usb.accessory

PRODUCT_PACKAGES += \
	audio.a2dp.default \
	audio.usb.default \
	audio.r_submix.default

# Filesystem management tools
PRODUCT_PACKAGES += \
    e2fsck

ifeq ($(strip $(is_secure)),1)
PRODUCT_PACKAGES += \
	libteec \
	tee-android-supplicant \
	xtest \
	helloworld-optee \
	aes-perf
endif

PRODUCT_PACKAGES += \
    TSCalibration   \
    libtslib    \
    inputraw    \
    pthres      \
    dejitter    \
    linear      \
    tscalib

PRODUCT_COPY_FILES += \
    external/tslib/ts.conf:system/etc/ts.conf

# Product Property
# common
PRODUCT_PROPERTY_OVERRIDES := \
	wifi.interface=wlan0 \
	wifi.supplicant_scan_interval=15 \
	ro.sf.lcd_density=160

# 4330 openl ui property
#PRODUCT_PROPERTY_OVERRIDES += \
	ro.opengles.version=131072 \
	ro.hwui.texture_cache_size=72 \
	ro.hwui.layer_cache_size=48 \
	ro.hwui.path_cache_size=16 \
	ro.hwui.shape_cache_size=4 \
	ro.hwui.gradient_cache_size=1 \
	ro.hwui.drop_shadow_cache_size=6 \
	ro.hwui.texture_cache_flush_rate=0.4 \
	ro.hwui.text_small_cache_width=1024 \
	ro.hwui.text_small_cache_height=1024 \
	ro.hwui.text_large_cache_width=2048 \
	ro.hwui.text_large_cache_height=1024 \
	ro.hwui.disable_scissor_opt=true

# setup dalvik vm configs.
#$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)
$(call inherit-product, frameworks/native/build/tablet-7in-hdpi-1024-dalvik-heap.mk)

# The OpenGL ES API level that is natively supported by this device.
# This is a 16.16 fixed point number
PRODUCT_PROPERTY_OVERRIDES += \
	ro.opengles.version=131072

PRODUCT_PACKAGES += \
	VolantisLayouts5p6818_general

PRODUCT_PACKAGES += \
	rtw_fwloader

# Enable AAC 5.1 output
#PRODUCT_PROPERTY_OVERRIDES += \
	media.aac_51_output_enabled=true

# set default USB configuration
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
	persist.sys.usb.config=mtp

# ota updater test
#PRODUCT_PACKAGES += \
	#OTAUpdateCenter

# wifi
ifeq ($(BOARD_WIFI_VENDOR),realtek)
$(call inherit-product-if-exists, hardware/realtek/wlan/config/p2p_supplicant.mk)
endif

ifeq ($(BOARD_WIFI_VENDOR),broadcom)
WIFI_BAND := 802_11_BG
$(call inherit-product-if-exists, hardware/broadcom/wlan/bcmdhd/firmware/bcm4329/device-bcm.mk)
endif

# 3G/LTE

# call slsiap
$(call inherit-product-if-exists, hardware/samsung_slsi/slsiap/slsiap.mk)

# google gms
#$(call inherit-product-if-exists, vendor/google/gapps/gapps.mk)

# Nexell Application
$(call inherit-product-if-exists, vendor/nexell/apps/nxvideoplayer.mk)
$(call inherit-product-if-exists, vendor/nexell/apps/nxaudioplayer.mk)
$(call inherit-product-if-exists, vendor/nexell/apps/smartsync.mk)

# iOS iAP/Tethering
BOARD_USES_IOS_IAP_TETHERING := true
ifeq ($(BOARD_USES_IOS_IAP_TETHERING),true)
$(call inherit-product-if-exists, hardware/samsung_slsi/slsiap/ios_tether/ios_tethering.mk)
endif
