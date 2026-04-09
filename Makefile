#   Copyright (C) 2022 John Törnblom
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; see the file COPYING. If not see
# <http://www.gnu.org/licenses/>.


DISC_LABEL := BD-JB-Poops-Autoloader

#
# Host tools
#
MAKEFILE_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
BDJSDK_HOME  ?= $(MAKEFILE_DIR)bdj-sdk
BDSIGNER     := $(BDJSDK_HOME)/host/bin/bdsigner
MAKEFS       := $(BDJSDK_HOME)/host/bin/makefs
JAVA8_HOME    ?= $(BDJSDK_HOME)/host/jdk8
JAVAC        := $(JAVA8_HOME)/bin/javac
JAR          := $(JAVA8_HOME)/bin/jar

export JAVA8_HOME


#
# Compilation artifacts
#
CLASSPATH     := $(BDJSDK_HOME)/target/lib/enhanced-stubs.zip:$(BDJSDK_HOME)/target/lib/bdjstack.jar:$(BDJSDK_HOME)/target/lib/pbp.jar
SOURCES       := $(wildcard src/jdk/internal/misc/*.java) $(wildcard src/org/bdj/*.java) $(wildcard src/org/bdj/sandbox/*.java) $(wildcard src/org/bdj/api/*.java) $(wildcard src/org/homebrew/*.java)
JFLAGS        := -Xlint:-options -source 1.4 -target 1.4

#
# Disc files
#
TMPL_DIRS  := $(shell find $(BDJSDK_HOME)/resources/AVCHD/ -type d)
TMPL_FILES := $(shell find $(BDJSDK_HOME)/resources/AVCHD/ -type f)

DISC_DIRS  := $(patsubst $(BDJSDK_HOME)/resources/AVCHD%,discdir%,$(TMPL_DIRS)) \
              discdir/BDMV/JAR
DISC_FILES := $(patsubst $(BDJSDK_HOME)/resources/AVCHD%,discdir%,$(TMPL_FILES)) \
              discdir/BDMV/JAR/00000.jar

#
# PS5 payload ELFs (built with ps5-payload-sdk; see subdir READMEs)
#
PS5_AUTOLOAD_ELF      := ps5_autoload_elf/ps5_autoload.elf
PS5_KILLDISCPLAYER_ELF := ps5_killdiscplayer_elf/ps5_killdiscplayer.elf

# Default goal must be the first target in this file (GNU Make).
all: $(DISC_LABEL).iso

$(PS5_AUTOLOAD_ELF):
	$(MAKE) -C ps5_autoload_elf

$(PS5_KILLDISCPLAYER_ELF):
	$(MAKE) -C ps5_killdiscplayer_elf

discdir:
	mkdir -p $(DISC_DIRS)

discdir/BDMV/JAR/00000.jar: discdir $(SOURCES) $(PS5_AUTOLOAD_ELF) $(PS5_KILLDISCPLAYER_ELF)
	$(JAVAC) $(JFLAGS) -cp $(CLASSPATH) $(SOURCES)
	mkdir -p build
	rsync -a bin/ build/
	rsync -a --exclude='*.java' --exclude='*.c' --exclude='*.bak' src/ build/
	rsync -a ps5_autoload_elf/ps5_autoload.elf build/ps5_autoload.elf
	rsync -a ps5_killdiscplayer_elf/ps5_killdiscplayer.elf build/ps5_killdiscplayer.elf
	$(JAR) cf $@ -C build/ .

discdir/%: discdir
	cp $(BDJSDK_HOME)/resources/AVCHD/$* $@


$(DISC_LABEL).iso: $(DISC_FILES)
	cp -r BDMV/META discdir/BDMV/
	cp -r BDMV/BDJO discdir/BDMV/
	$(MAKEFS) -m 16m -t udf -o T=bdre,v=2.50,L=$(DISC_LABEL) $@ discdir

clean:
	$(MAKE) -C ps5_autoload_elf clean
	$(MAKE) -C ps5_killdiscplayer_elf clean
	rm -rf build META-INF $(DISC_LABEL).iso discdir src/jdk/internal/misc/*.class src/org/bdj/*.class src/org/bdj/sandbox/*.class src/org/bdj/api/*.class src/org/homebrew/*.class build

.PHONY: all clean
