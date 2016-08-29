1. Copy the ABS `core/linux` tree into a scratch directory
2. Copy `acs_override.patch` into working directory
3. Apply `linux_pkgbuild.patch` to working directory: `patch -p1 -i /path/to/linux_pkgbuild.patch`
4. Execute `updpkgsums` in working directory
5. `makepkg -s`
6. Install packages
7. ???
8. Profit
