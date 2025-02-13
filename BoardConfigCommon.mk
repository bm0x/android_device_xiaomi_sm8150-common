#
# Copyright (C) 2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

COMMON_PATH := device/xiaomi/sm8150-common

# APEX
DEXPREOPT_GENERATE_APEX_IMAGE := true

# Audio
AUDIO_FEATURE_ENABLED_AHAL_EXT := false
AUDIO_FEATURE_ENABLED_DLKM := true
AUDIO_FEATURE_ENABLED_DS2_DOLBY_DAP := false
AUDIO_FEATURE_ENABLED_DTS_EAGLE := false
AUDIO_FEATURE_ENABLED_DYNAMIC_LOG := false
AUDIO_FEATURE_ENABLED_EXTENDED_COMPRESS_FORMAT := true
AUDIO_FEATURE_ENABLED_GEF_SUPPORT := true
AUDIO_FEATURE_ENABLED_HW_ACCELERATED_EFFECTS := false
AUDIO_FEATURE_ENABLED_INSTANCE_ID := true
AUDIO_FEATURE_ENABLED_PROXY_DEVICE := true
AUDIO_FEATURE_ENABLED_SSR := false
BOARD_SUPPORTS_SOUND_TRIGGER := true
BOARD_USES_ALSA_AUDIO := true
USE_CUSTOM_AUDIO_POLICY := 1

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(COMMON_PATH)/bluetooth/include

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := msmnile
TARGET_NO_BOOTLOADER := true

# Camera
TARGET_USES_QTI_CAMERA_DEVICE := true
USE_DEVICE_SPECIFIC_CAMERA := true

# Display
TARGET_DISABLED_UBWC := true
TARGET_USES_COLOR_METADATA := true
TARGET_USES_DISPLAY_RENDER_INTENTS := true
TARGET_USES_DRM_PP := true
TARGET_USES_GRALLOC1 := true
TARGET_USES_GRALLOC4 := true
TARGET_USES_HWC2 := true
TARGET_USES_ION := true

# DRM
TARGET_ENABLE_MEDIADRM_64 := true

# Filesystem
TARGET_FS_CONFIG_GEN := $(COMMON_PATH)/config.fs

# Fingerprint
ifeq ($(TARGET_HAS_FOD),true)
TARGET_SURFACEFLINGER_FOD_LIB := //$(COMMON_PATH):libfod_extension.xiaomi_msmnile
endif

# FM
BOARD_HAVE_QCOM_FM := true

# HIDL
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := \
    $(COMMON_PATH)/framework_compatibility_matrix.xml \
    vendor/lineage/config/device_framework_matrix.xml
DEVICE_MATRIX_FILE += $(COMMON_PATH)/compatibility_matrix.xml
DEVICE_MANIFEST_FILE += $(COMMON_PATH)/manifest.xml
ODM_MANIFEST_SKUS += nfc
ODM_MANIFEST_NFC_FILES := $(COMMON_PATH)/manifest_nfc.xml

# NFC
TARGET_USES_NQ_NFC := true

CORE_PARTITIONS := system vendor
ADDITIONAL_PARTITIONS := odm product system_ext

ALL_PARTITIONS := $(CORE_PARTITIONS)
ifeq ($(TARGET_USE_DYNAMIC_PARTITIONS),true)
ALL_PARTITIONS += $(ADDITIONAL_PARTITIONS)
endif # TARGET_USE_DYNAMIC_PARTITIONS

$(foreach p, $(call to-upper, $(ALL_PARTITIONS)), \
    $(eval BOARD_$(p)IMAGE_FILE_SYSTEM_TYPE := ext4) \
    $(eval TARGET_COPY_OUT_$(p) := $(call to-lower, $(p))))

# Partitions - reserved size
ifeq ($(TARGET_USE_DYNAMIC_PARTITIONS),true)
SSI_PARTITIONS := system product system_ext
VENDOR_PARTITIONS := vendor odm

SSI_PARTITIONS := $(call to-upper, $(SSI_PARTITIONS))
VENDOR_PARTITIONS := $(call to-upper, $(VENDOR_PARTITIONS))

VENDOR_PARTITIONS_RESERVED_SIZE := 30720000
ifneq ($(WITH_GMS),true)
SSI_PARTITIONS_RESERVED_SIZE := 1258291200
else
SSI_PARTITIONS_RESERVED_SIZE := $(VENDOR_PARTITIONS_RESERVED_SIZE)
endif

ifneq ($(WITH_GMS),true)
$(foreach p, $(SSI_PARTITIONS), $(eval BOARD_$(p)IMAGE_EXTFS_INODE_COUNT := -1))
endif

$(foreach p, $(SSI_PARTITIONS), $(eval BOARD_$(p)IMAGE_PARTITION_RESERVED_SIZE := $(SSI_PARTITIONS_RESERVED_SIZE)))
$(foreach p, $(VENDOR_PARTITIONS), $(eval BOARD_$(p)IMAGE_PARTITION_RESERVED_SIZE := $(VENDOR_PARTITIONS_RESERVED_SIZE)))
endif # TARGET_USE_DYNAMIC_PARTITIONS

# Power
TARGET_TAP_TO_WAKE_NODE := "/sys/touchpanel/double_tap"

# Properties
TARGET_ODM_PROP += $(COMMON_PATH)/odm.prop
TARGET_PRODUCT_PROP += $(COMMON_PATH)/product.prop
TARGET_SYSTEM_PROP += $(COMMON_PATH)/system.prop
TARGET_VENDOR_PROP += $(COMMON_PATH)/vendor.prop

# Recovery
ifeq ($(TARGET_USE_DYNAMIC_PARTITIONS),true)
TARGET_RECOVERY_FSTAB := $(COMMON_PATH)/rootdir/etc/fstab_dynamic.qcom
else
TARGET_RECOVERY_FSTAB := $(COMMON_PATH)/rootdir/etc/fstab_legacy.qcom
endif
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_INCLUDE_RECOVERY_DTBO := true
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Releasetools
TARGET_RELEASETOOLS_EXTENSIONS := $(COMMON_PATH)

# RIL
ENABLE_VENDOR_RIL_SERVICE := true

# Security patch level
VENDOR_SECURITY_PATCH := 2021-11-01

# Sepolicy
include device/qcom/sepolicy_vndr/SEPolicy.mk
BOARD_PLAT_PRIVATE_SEPOLICY_DIR += $(COMMON_PATH)/sepolicy/private
BOARD_PLAT_PUBLIC_SEPOLICY_DIR += $(COMMON_PATH)/sepolicy/public
BOARD_VENDOR_SEPOLICY_DIRS += $(COMMON_PATH)/sepolicy/vendor

# Treble
BOARD_VNDK_VERSION := current

# WiFi
BOARD_WLAN_DEVICE := qcwcn
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
WIFI_DRIVER_DEFAULT := qca_cld3
WIFI_DRIVER_STATE_CTRL_PARAM := "/dev/wlan"
WIFI_DRIVER_STATE_OFF := "OFF"
WIFI_DRIVER_STATE_ON := "ON"
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
WPA_SUPPLICANT_VERSION := VER_0_8_X

# Inherit the proprietary files
include vendor/xiaomi/sm8150-common/BoardConfigVendor.mk
