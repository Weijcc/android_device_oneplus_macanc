#
# Copyright (C) 2021-2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

USE_PREBUILT_KERNEL ?= true

# Partitions
BOARD_SUPER_PARTITION_SIZE := 16886267904

# Include the common OEM chipset BoardConfig.
include device/oneplus/sm8850-common/BoardConfigCommon.mk

DEVICE_PATH := device/oneplus/macanc

# Assert
TARGET_OTA_ASSERT_DEVICE := OP6117L1

# Display
TARGET_SCREEN_DENSITY := 540

# Kernel
ifeq ($(USE_PREBUILT_KERNEL), true)
include device/oneplus/macanc-kernel/BoardConfig.mk
else
TARGET_KERNEL_ADDITIONAL_FLAGS += CONFIG_MACANC_DTB=y
endif

# Properties
TARGET_ODM_PROP += $(DEVICE_PATH)/odm.prop
TARGET_SYSTEM_EXT_PROP += $(DEVICE_PATH)/system_ext.prop
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# Recovery
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 103

# Include the proprietary files BoardConfig.
include vendor/oneplus/macanc/BoardConfigVendor.mk

# Legacy vendor blobs have unresolved symbols (face_tee_*, WFD audio ABI)
BUILD_BROKEN_PREBUILT_ELF_FILES := true

