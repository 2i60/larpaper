<img width="2561" height="504" alt="635699500-3cd58b33-5635-4d3f-bf30-66942ee5d793" src="https://github.com/user-attachments/assets/2ed0083e-7209-4ee2-bd49-fc015479ace3" />

larpaper is a fullscreen terminal screensaver built with Kitty, Terminal Text
Effects, and swayidle.

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

larpaper is written entirely in bash, so it's pretty straightforward: Download or clone
the source code, then install the files manually:

```bash
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/larpaper
mkdir -p ~/.local/share/applications
mkdir -p ~/.config/autostart

install -m 755 larpaper.sh ~/.local/bin/larpaper
install -m 755 launch-larpaper.sh ~/.local/bin/launch-larpaper
install -m 755 larpaper-idle.sh ~/.local/bin/larpaper-idle
install -m 644 art.txt ~/.local/share/larpaper/art.txt
install -m 644 larpaper.desktop ~/.local/share/applications/larpaper.desktop
install -m 644 larpaper-idle.desktop ~/.config/autostart/larpaper-idle.desktop
```

Make sure `~/.local/bin` is in your `PATH`. You can then preview larpaper with:

```bash
launch-larpaper --showoff
```

The KDE idle watcher starts larpaper after five minutes. Log out and back in to
start the new autostart entry immediately, or run `larpaper-idle` yourself.

Edit `art.txt` to customize the artwork in a clone. After installation,
the installed copy is at `~/.local/share/larpaper/art.txt`.
