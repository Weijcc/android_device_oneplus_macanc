#
# Copyright (C) 2021-2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Partitions
BOARD_SUPER_PARTITION_SIZE := 16886267904

# Include the common OEM chipset BoardConfig.
include device/oneplus/sm8850-common/BoardConfigCommon.mk

# Kernel
# Build only the macan/macanc DTBO entries (4) instead of all CANOE boards
# (24 entries would exceed the 24 MiB DTBO partition).
TARGET_KERNEL_BAZEL_FLAGS += --//vendor/oneplus/sm8850:dtbo_config=//vendor/oneplus/sm8850-devicetrees:macan_dtbo_config

DEVICE_PATH := device/oneplus/macanc

# Stock ELF binaries/libraries are installed through PRODUCT_COPY_FILES
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Assert
TARGET_OTA_ASSERT_DEVICE := OP6117L1

# Display
TARGET_SCREEN_DENSITY := 455

# Properties
TARGET_ODM_PROP += $(DEVICE_PATH)/odm.prop
TARGET_SYSTEM_EXT_PROP += $(DEVICE_PATH)/system_ext.prop
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# Recovery
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 103

# Include the proprietary files BoardConfig.
include vendor/oneplus/macanc/BoardConfigVendor.mk
