#
#  Copyright (c) 2011 Arduino.  All right reserved.
#
#  This library is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Lesser General Public
#  License as published by the Free Software Foundation; either
#  version 2.1 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#  See the GNU Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public
#  License along with this library; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

# Tool suffix when cross-compiling

ARM_GCC_TOOLCHAIN=../tools/gcc-arm-none-eabi-4.8.3-2014q1/bin


CROSS_COMPILE = arm-none-eabi-



# Compilation tools
AR = $(CROSS_COMPILE)ar
CC = $(CROSS_COMPILE)gcc
AS = $(CROSS_COMPILE)as
NM = $(CROSS_COMPILE)nm
RM=rm -Rf

SEP=/

# ---------------------------------------------------------------------------------------
# C Flags

CFLAGS = -g -mcpu=cortex-m3
CFLAGS += -mthumb
CFLAGS += -c -nostartfiles -fno-short-enums
CFLAGS += -Wall -Wpointer-arith -Wstrict-prototypes -Wundef
CFLAGS += -Wno-write-strings
CFLAGS += --save-temps
CFLAGS += -MMD -MP
CFLAGS += -fno-common -fmessage-length=0 -fno-exceptions 
CFLAGS += -ffunction-sections -fdata-sections
CFLAGS += -fomit-frame-pointer 
CFLAGS += -std=gnu99
CFLAGS += -O2 $(INCLUDES) -D$(CHIP)



# ---------------------------------------------------------------------------------------
# ASM Flags

ASFLAGS = -mcpu=cortex-m3 -mthumb -Wall -a -g $(INCLUDES)

