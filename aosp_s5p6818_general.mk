#
# Copyright 2013 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
PRODUCT_PACKAGES += \
    Launcher3

PRODUCT_PACKAGES += \
    sensors.s5p6818_general

PRODUCT_PROPERTY_OVERRIDES := \
        net.dns1=8.8.8.8 \
        net.dns2=8.8.4.4

$(call inherit-product, device/nexell/s5p6818_general/product.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)

PRODUCT_NAME := aosp_s5p6818_general
PRODUCT_DEVICE := s5p6818_general
PRODUCT_BRAND := Android
PRODUCT_MODEL := AOSP on s5p6818_general
PRODUCT_MANUFACTURER := NEXELL


