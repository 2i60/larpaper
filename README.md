<img width="2561" height="504" alt="635699500-3cd58b33-5635-4d3f-bf30-66942ee5d793" src="https://github.com/user-attachments/assets/2ed0083e-7209-4ee2-bd49-fc015479ace3" />

<sub> having any issues? reach out to me on discord! @mozegaku </sub> 

larpaper is a fullscreen terminal screensaver built with Kitty, Terminal Text
Effects, and swayidle.

## FYI
this was made with KDE in mind, so most things are built around that. soon i'll work on availability for other distros like hyprland, GNOME, and more as time goes on. 

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

The installer opens in a terminal when launched graphically, verifies every
required source file, downloads any missing files, and asks before installing.
It reports each step and displays the configured Larpaper artwork when done.

## Set up from source

larpaper is written entirely in bash, so it's pretty straightforward: Download or clone
the source code, then install the files manually:

```bash
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/applications
mkdir -p ~/.config/autostart
mkdir -p ~/.config/larpaper

install -m 755 larpaper.sh ~/.local/bin/larpaper
install -m 755 launch-larpaper.sh ~/.local/bin/launch-larpaper
install -m 755 larpaper-idle.sh ~/.local/bin/larpaper-idle
install -m 644 larpaper.conf ~/.config/larpaper/larpaper.conf
install -m 644 art.txt ~/.config/larpaper/art.txt
install -m 644 larpaper.desktop ~/.local/share/applications/larpaper.desktop
install -m 644 larpaper-idle.desktop ~/.config/autostart/larpaper-idle.desktop
```

Make sure `~/.local/bin` is in your `PATH`. You can then preview larpaper with:

```bash
launch-larpaper --showoff
```

The KDE idle watcher starts larpaper after five minutes. Log out and back in to
start the new autostart entry immediately, or run `larpaper-idle` yourself.

## Configuration

Release installs keep both editable files together in `~/.config/larpaper/`:

- `larpaper.conf` controls the idle timeout, window appearance, and Terminal
  Text Effects settings.
- `art.txt` contains the artwork displayed by Larpaper.

When running from a source checkout, edit the copies beside the scripts in the
repository instead.

## Uninstall a release

Release archives include an uninstaller. Run:

```bash
uninstall-larpaper
```

This stops Larpaper and its idle watcher, then removes only files installed by
the release. It does not remove source checkouts or unrelated Kitty, `tte`, or
`swayidle` installations.
