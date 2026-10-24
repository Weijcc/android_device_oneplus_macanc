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

# DTBO
# The OEM dtbo partition is 24 MiB (BOARD_DTBOIMG_PARTITION_SIZE) and cannot be
# enlarged without rewriting the GPT. The kernel packages every canoe overlay
# (infiniti, fairlady, iceland, dengta) alongside the four macan ones, which
# totals ~28 MiB and overflows the partition:
#
#   avbtool: Image size of 28127954 exceeds maximum image size of 25096192
#
# dtbo.img is the OEM blob taken from the PLR110_16.0.10.500(CN01) OTA
# (payload partition "dtbo"), with its AVB hash footer stripped:
#
#   payload-dumper-go -partitions dtbo -o out payload.bin
#   avbtool erase_footer --image out/dtbo.img
#
# It carries the same four macan overlays the kernel would build here
# (macan-24855-alor-overlay, macan-24877-alor-overlay-IN,
# macan-24877-alor-overlay-EU-US, macan-24855-alor-overlay-dvt2) but without
# the other OEM projects, and keeps the OEM page size of 4096.
#
# Use it as a prebuilt and keep the kernel from rebuilding it.
# TARGET_NEEDS_DTBOIMAGE and BOARD_KERNEL_SEPARATED_DTBO are cleared so
# build/tasks/kernel.mk does not add a rule writing to
# BOARD_PREBUILT_DTBOIMAGE; build/make/core/Makefile then just copies it and
# appends the AVB hash footer.
BOARD_KERNEL_SEPARATED_DTBO := false
TARGET_NEEDS_DTBOIMAGE := false
BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PATH)/dtbo.img

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

