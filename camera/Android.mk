ifeq ($(BOARD_HAS_CAMERA),true)

LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)
LOCAL_C_INCLUDES += \
	frameworks/native/include \
	system/media/camera/include \
	hardware/samsung_slsi/slsiap/include \
	hardware/samsung_slsi/slsiap/libcamerasensor
LOCAL_SHARED_LIBRARIES := liblog libv4l2-nexell
LOCAL_STATIC_LIBRARIES := libcamerasensor
LOCAL_SRC_FILES := board-camera.cpp
LOCAL_MODULE := libcamera-s5p6818_general
LOCAL_MODULE_TAGS := optional
include $(BUILD_STATIC_LIBRARY)

endif
