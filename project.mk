# Add inputs and outputs from these tool invocations to the build variables
OUT_DIR += \
/$(SRC_PATH) \
/$(SRC_PATH)/common \
/$(SRC_PATH)/devices
 
OBJS += \
$(OUT_PATH)/$(SRC_PATH)/common/main.o \
$(OUT_PATH)/$(SRC_PATH)/devices/device.o \
$(OUT_PATH)/$(SRC_PATH)/devices/kaskad_1_mt.o \
$(OUT_PATH)/$(SRC_PATH)/devices/kaskad_11.o \
$(OUT_PATH)/$(SRC_PATH)/devices/mercury_206.o \
$(OUT_PATH)/$(SRC_PATH)/devices/energomera_ce102m.o \
$(OUT_PATH)/$(SRC_PATH)/config.o \
$(OUT_PATH)/$(SRC_PATH)/app_ui.o \
$(OUT_PATH)/$(SRC_PATH)/app_uart.o \
$(OUT_PATH)/$(SRC_PATH)/app_utility.o \
$(OUT_PATH)/$(SRC_PATH)/electricityMeterEpCfg.o \
$(OUT_PATH)/$(SRC_PATH)/zcl_electricityMeterCb.o \
$(OUT_PATH)/$(SRC_PATH)/zb_appCb.o \
$(OUT_PATH)/$(SRC_PATH)/electricityMeter.o


#$(OUT_PATH)/$(SRC_PATH)/app_ui.o \
#$(OUT_PATH)/$(SRC_PATH)/sampleLight.o \
#$(OUT_PATH)/$(SRC_PATH)/sampleLightCtrl.o \
#$(OUT_PATH)/$(SRC_PATH)/sampleLightEpCfg.o \
#$(OUT_PATH)/$(SRC_PATH)/zb_afTestCb.o \
#$(OUT_PATH)/$(SRC_PATH)/zb_appCb.o \
#$(OUT_PATH)/$(SRC_PATH)/zcl_colorCtrlCb.o \
#$(OUT_PATH)/$(SRC_PATH)/zcl_levelCb.o \
#$(OUT_PATH)/$(SRC_PATH)/zcl_onOffCb.o \
#$(OUT_PATH)/$(SRC_PATH)/zcl_sampleLightCb.o \
#$(OUT_PATH)/$(SRC_PATH)/zcl_sceneCb.o 





#$(OUT_PATH)/$(SRC_PATH)/watermeter.o \
#$(OUT_PATH)/$(SRC_PATH)/watermeterEpCfg.o \
#$(OUT_PATH)/$(SRC_PATH)/zb_appCb.o \

# Each subdirectory must supply rules for building sources it contributes
$(OUT_PATH)/$(SRC_PATH)/%.o: $(SRC_PATH)/%.c 
	@echo 'Building file: $<'
	@$(CC) $(GCC_FLAGS) $(INCLUDE_PATHS) -c -o"$@" "$<"


