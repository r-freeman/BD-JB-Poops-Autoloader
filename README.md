# BD-JB-Poops-Autoloader

## About this project

This project is based on [BD-UN-JB-Poops-Autoloader](https://github.com/owendswang/BD-UN-JB-Poops-Autoloader) by [owenswang](https://github.com/owendswang), which is a fork of [BD-UN-JB](https://github.com/Gezine/BD-UN-JB) by [Gezine](https://github.com/Gezine). BD-JB-Poops-Autoloader takes advantage of an exploit in the PS5 Blu-ray stack, which allows execution of [Poops](https://github.com/jaigaresc/Poops-PS5-Java) to take full control of the PS5 kernel.

## Requirements

* PS5 with firmware <=7.61 or up to 12.00 using [SWRR](https://limitedrungames.com/products/limited-run-290-star-wars-racer-revenge-premium-edition-ps4) and [BD-UN-JB](https://github.com/Gezine/BD-UN-JB) to unpatch the Blu-ray stack.
* Blu-ray drive and BD-RE or BD-R disc to burn the ISO.


## Features

* ps5_autoload.elf which allows you to load ELF payloads from a USB device.
* ps5_killdiscplayer.elf automatically closes the disc player.
* Poops-PS5-Java v1.1 which was ported to Java by jaigaresc.

## Build and compile

Use Debian-based environment to build and compile the project. I'm using [wsl](https://learn.microsoft.com/en-us/windows/wsl/install) with Ubuntu distribution on Windows 11. After installing wsl and Ubuntu, start the environment using `wsl -d Ubuntu` and follow the instructions below to install the project dependencies.

### Set up bdj-sdk

```bash
ryan@localhost:~$ sudo apt-get update && sudo apt-get upgrade
ryan@localhost:~$ sudo apt-get install build-essential libbsd-dev git pkg-config openjdk-8-jdk-headless
ryan@localhost:~$ git clone --recurse-submodules https://github.com/john-tornblom/bdj-sdk
ryan@localhost:~$ ln -s /usr/lib/jvm/java-8-openjdk-amd64 bdj-sdk/host/jdk8
ryan@localhost:~$ ln -s /usr/lib/jvm/java-11-openjdk-amd64 bdj-sdk/host/jdk11
ryan@localhost:~$ make -C bdj-sdk/host/src/makefs_termux
ryan@localhost:~$ make -C bdj-sdk/host/src/makefs_termux install DESTDIR=$PWD/bdj-sdk/host
ryan@localhost:~$ make -C bdj-sdk/target
```

### Set up ps5-payload-sdk

Install dependencies

```bash
ryan@localhost:~$ sudo apt-get install zip bash clang-18 lld-18
ryan@localhost:~$ sudo apt-get install socat cmake meson pkg-config
```

Download and install ps5-payload-sdk

```bash
ryan@localhost:~$ wget https://github.com/ps5-payload-dev/sdk/releases/latest/download/ps5-payload-sdk.zip
ryan@localhost:~$ sudo unzip -d /opt ps5-payload-sdk.zip
```

E: Unable to locate package clang-18

```bash
ryan@localhost:~$ wget -qO- https://apt.llvm.org/llvm.sh | bash -s -- 18
```

### Compile the project

Use `make` at the project root to compile ps5_autoload.elf, ps5_killdiscplayer.elf and BD-JB-Poops-Autoloader.iso. Burn the ISO to disc using ImgBurn or similar software.

### Todo

- [ ] Add CI/CD pipeline using GitHub Actions.

---

### Credits

* **[owendswang](https://github.com/owendswang)** — [BD-UN-JB-Poops-Autoloader](https://github.com/owendswang/BD-UN-JB-Poops-Autoloader).
* **[jaigaresc](https://github.com/jaigaresc)** — [Poops-PS5-Java](https://github.com/jaigaresc/Poops-PS5-Java).
* **[Gezine](https://github.com/Gezine/BD-UN-JB)** — BD-UN-JB for basics.  
* **[TheFlow](https://github.com/theofficialflow)** — BD-JB documentation & native code execution sources.  
* **[hammer-83](https://github.com/hammer-83)** — PS5 Remote JAR Loader reference.  
* **[john-tornblom](https://github.com/john-tornblom)** — [BDJ-SDK](https://github.com/john-tornblom/bdj-sdk) and [ps5-payload-sdk](https://github.com/ps5-payload-dev/sdk/) used for compilation.  
* **[kuba--](https://github.com/kuba--)** — [zip](https://github.com/kuba--/zip) used for bdj_unpatch and ps5_autoload elf payload.  
* **[jaigaresc](https://github.com/jaigaresc/Poops-PS5-Java)** — used for jar payload.
* **[itsPLK](https://github.com/itsPLK/ps5_y2jb_autoloader):** Autoloader theory.
* **[BenNoxXD](https://github.com/BenNoxXD/PS5-BDJ-HEN-loader):** Method to close disc player.
* **[drakmor](https://github.com/drakmor):** [ftpsrv](https://github.com/drakmor/ftpsrv), [kstuff](https://github.com/drakmor/kstuff-lite), [shadowmountplus](https://github.com/drakmor/ShadowMountPlus).

---

## Disclaimer

This tool is provided as-is for research and development purposes only.  
Use at your own risk.  
The developers are not responsible for any damage, data loss, or other consequences resulting from the use of this software.  
