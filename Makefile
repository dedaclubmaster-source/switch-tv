#---------------------------------------------------------------------------------
# Switch TV - Nintendo Switch homebrew
#---------------------------------------------------------------------------------

ifeq ($(strip $(DEVKITPRO)),)
$(error "Please set DEVKITPRO in your environment. (eg: export DEVKITPRO=/opt/devkitpro)")
endif

include $(DEVKITPRO)/libnx/switch_rules

#---------------------------------------------------------------------------------
# Application name
#---------------------------------------------------------------------------------
TARGET      := switch-tv
BUILD       := build
SOURCES     := source
DATA        :=
INCLUDES    :=

APP_TITLE   := Switch TV
APP_AUTHOR  := DedaClubMaster
APP_VERSION := 0.1.0

#---------------------------------------------------------------------------------
# options for code generation
#---------------------------------------------------------------------------------
ARCH        := -march=armv8-a+crc+crypto -mtune=cortex-a57 -mtp=soft

CFLAGS      := -g -Wall -O2 -ffunction-sections \
               $(ARCH) $(DEFINES)

CXXFLAGS    := $(CFLAGS) -fno-rtti -fno-exceptions -std=gnu++17

ASFLAGS     := -g $(ARCH)
LDFLAGS     := -specs=$(DEVKITPRO)/libnx/switch.specs -g $(ARCH) -Wl,-Map,$(notdir $*.map)

LIBS        := -lnx

#---------------------------------------------------------------------------------
# list of directories containing libraries, this must be the top level containing
# include and lib
#---------------------------------------------------------------------------------
LIBDIRS     := $(PORTLIBS) $(LIBNX)

#---------------------------------------------------------------------------------
# no real need to edit anything below this line unless you know what you are doing
#---------------------------------------------------------------------------------
ifneq ($(BUILD),$(notdir $(CURDIR)))
#---------------------------------------------------------------------------------
export OUTPUT  := $(CURDIR)/$(TARGET)
export TOPDIR  := $(CURDIR)

export VPATH   := $(foreach dir,$(SOURCES),$(CURDIR)/$(dir)) \
                  $(foreach dir,$(DATA),$(CURDIR)/$(dir))

export DEPSDIR := $(CURDIR)/$(BUILD)

CFILES      := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES    := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
SFILES      := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))
BINFILES    := $(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.*)))

export OFILES := $(addsuffix .o,$(BINFILES)) \
                 $(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(SFILES:.s=.o)

export INCLUDE := $(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
                  $(foreach dir,$(LIBDIRS),-I$(dir)/include) \
                  -I$(CURDIR)/$(BUILD)

.PHONY: all clean
all: $(BUILD)

$(BUILD):
	@mkdir -p $@
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

clean:
	@echo clean ...
	@rm -fr $(BUILD) $(TARGET).nro $(TARGET).elf

#---------------------------------------------------------------------------------
else
#---------------------------------------------------------------------------------
DEPENDS := $(OFILES:.o=.d)

$(OUTPUT).nro: $(OUTPUT).elf

$(OUTPUT).elf: $(OFILES)

-include $(DEPENDS)

#---------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------
