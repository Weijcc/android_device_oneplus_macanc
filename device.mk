#
# Copyright (C) 2021-2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# AAPT
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxxhdpi

# Page size
# macanc's kernel uses 4K pages; stock blobs are 4K-aligned.
PRODUCT_MAX_PAGE_SIZE_SUPPORTED := 4096

# Audio
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio/audio_module_config_primary.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/audio_module_config_primary.xml \
    $(LOCAL_PATH)/configs/audio/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    $(LOCAL_PATH)/configs/audio/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml

# Audio HAL configs. PAL resolves these from the sound card name
# ("alor-mtp-wcd9378-snd-card"); when they are missing ResourceManager throws
# during HAL init, audiohalservice aborts and boot never completes.
PRODUCT_COPY_FILES += \
    hardware/qcom-caf/sm8850/audio/pal/configs/qcom/mobile/canoe/mixer_paths_alor_cdp.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_alor/mixer_paths_alor_cdp.xml \
    hardware/qcom-caf/sm8850/audio/pal/configs/qcom/mobile/canoe/mixer_paths_alor_mtp_wcd9378.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_alor/mixer_paths_alor_mtp_wcd9378.xml \
    hardware/qcom-caf/sm8850/audio/pal/configs/qcom/mobile/canoe/mixer_paths_alor_mtp_wcd939x.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_alor/mixer_paths_alor_mtp_wcd939x.xml \
    hardware/qcom-caf/sm8850/audio/pal/configs/qcom/mobile/canoe/mixer_paths_alor_qrd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_alor/mixer_paths_alor_qrd.xml \
    hardware/qcom-caf/sm8850/audio/pal/configs/qcom/mobile/canoe/resourcemanager_alor_cdp.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_alor/resourcemanager_alor_cdp.xml \
    hardware/qcom-caf/sm8850/audio/pal/configs/qcom/mobile/canoe/resourcemanager_alor_mtp_wcd9378.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_alor/resourcemanager_alor_mtp_wcd9378.xml \
    hardware/qcom-caf/sm8850/audio/pal/configs/qcom/mobile/canoe/resourcemanager_alor_mtp_wcd939x.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_alor/resourcemanager_alor_mtp_wcd939x.xml \
    hardware/qcom-caf/sm8850/audio/pal/configs/qcom/mobile/canoe/resourcemanager_alor_qrd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_alor/resourcemanager_alor_qrd.xml \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/canoe/quasar_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_alor/quasar_config.xml \
    hardware/interfaces/audio/aidl/default/audio_effects_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_alor/audio_effects_config_stub.xml

PRODUCT_COPY_FILES += \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/canoe/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_alor_qssi/audio_policy_configuration.xml \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/canoe/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_canoe_qssi/audio_policy_configuration.xml

PRODUCT_COPY_FILES += \
    hardware/qcom-caf/sm8850/audio/primary-hal/configs/common/bluetooth_qti_hearing_aid_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_qti_hearing_aid_audio_policy_configuration.xml


# ACDB
PRODUCT_PACKAGES += \
    acdbdata_alor_mtp_symlink \
    acdbdata_alor_mtp_wcd9378_symlink

# Camera
# The prebuilt camera provider links against the AIDL NDK library; without an
# explicit PRODUCT_PACKAGES entry Soong never installs it into /vendor/lib64.
PRODUCT_PACKAGES += \
    android.hardware.camera.provider-V3-ndk.vendor

# Boot animation
TARGET_SCREEN_HEIGHT := 2800
TARGET_SCREEN_WIDTH := 1272

# Display
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/display/displayconfig.xml:$(TARGET_COPY_OUT_VENDOR)/etc/displayconfig/display_id_4630946700822127507.xml

# Init
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init/init.macanc.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.macanc.rc

# Keymint
PRODUCT_PACKAGES += \
    android.hardware.security.keymint3-service.strongbox.nxp \
    android.hardware.weaver-service.nxp

# LiveDisplay
$(call soong_config_set_bool,OPLUS_LINEAGE_LIVEDISPLAY_HAL,ENABLE_SE,false)

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay-lineage

PRODUCT_PACKAGES += \
    OPlusFrameworksResTarget \
    OPlusSettingsProviderResTarget \
    OPlusSettingsResTarget \
    OPlusSystemUIResTarget \
    OPlusWifiResTarget

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Touch features
$(call soong_config_set_bool,OPLUS_LINEAGE_TOUCH_HAL,ENABLE_GM,true)

# Vibrator
PRODUCT_PACKAGES += \
    android.hardware.vibrator.service.oplus-richtap

# Inherit from the common OEM chipset makefile.
$(call inherit-product, device/oneplus/sm8850-common/common.mk)

# The in-tree qcom-caf AGM/PAL/GSL/ACDB libraries do not match the proprietary
# audiohalservice.qti and *.acdb/*.qwsp blobs: gsl_init fails with -114
# ("Register modules ... failure:9"), agmservice never registers and
# audiohalservice aborts after 30 s, after which the AOSP stub HAL takes over
# -- no sound, and Bluetooth stays stuck in TURNING_ON. The stock blobs are
# shipped over the in-tree builds via PRODUCT_COPY_FILES in
# vendor/oneplus/sm8850-common/sm8850-common-vendor.mk.
#
# Note: PRODUCT_PACKAGES cannot drop those modules here, because
# inherit-product only merges the child list after this file has been parsed.

# Inherit from the proprietary files makefile.
$(call inherit-product, vendor/oneplus/macanc/macanc-vendor.mk)
