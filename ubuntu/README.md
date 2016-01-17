# Ubuntu-specific things

## Packages and APT sources
Copy contents of `sources.list.d` to `/etc/apt/sources.list.d`, then install each package listed in PACKAGES with
`sudo apt install $PACKAGE`

## Icon Sets/Themes
Copy all folders in `icons` to `~/.icons` (creating the folder if needed), then change the icon set in Unity Tweak Tool.
The theme is also changed in Unity Tweak Tool (usually set to Arc-darker, which is installed via the above.)
