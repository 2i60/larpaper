# Larpaper

Larpaper is a fullscreen terminal screensaver built with Kitty, Terminal Text
Effects, and swayidle. It includes the original default ASCII artwork.

## Requirements

- Bash
- Kitty
- [Terminal Text Effects (`tte`)](https://github.com/ChrisBuilds/terminaltexteffects)
- swayidle
- util-linux (`flock`)

## Quick setup

Download `larpaper-quick-setup.tar.gz` from the latest GitHub Release, extract
it, and run the included quick installer:

```bash
./quick-setup
```

## Set up from source

Larpaper is written in Bash and does not need to be compiled. Download or clone
the source code, then install the files manually:

```bash
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/larpaper
mkdir -p ~/.local/share/applications
mkdir -p ~/.config/autostart

install -m 755 src/larpaper.sh ~/.local/bin/larpaper
install -m 755 src/launch-larpaper.sh ~/.local/bin/launch-larpaper
install -m 755 src/larpaper-idle.sh ~/.local/bin/larpaper-idle
install -m 644 assets/art.txt ~/.local/share/larpaper/art.txt
install -m 644 desktop/larpaper.desktop ~/.local/share/applications/larpaper.desktop
install -m 644 desktop/larpaper-idle.desktop ~/.config/autostart/larpaper-idle.desktop
```

Make sure `~/.local/bin` is in your `PATH`. You can then preview Larpaper with:

```bash
launch-larpaper --showoff
```

The KDE idle watcher starts Larpaper after five minutes. Log out and back in to
start the new autostart entry immediately, or run `larpaper-idle` yourself.

## Project layout

```text
larpaper/
├── assets/       Default ASCII artwork
├── src/          Bash source for the screensaver, launcher, and idle watcher
├── desktop/      Application and KDE autostart entries
└── README.md
```

Edit `assets/art.txt` to customize the artwork in a clone. After installation,
the installed copy is at `~/.local/share/larpaper/art.txt`.
