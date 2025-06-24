<h1 align="center">Andrew's dotfiles</h1>

<p align="center">
  (Heavily inspired by <a href="https://github.com/mathiasbynens/dotfiles">Mathias</a> 🙏)
</p>

## Quickstart

You'll need `git` on your new machine in order to clone this repo. The easiest
way on a Mac is by installing the _Xcode Command Line Tools_ (which we'll need
later anyway…)

```bash
sudo softwareupdate -i -a
xcode-select --install
```

Then simply run the `bootstrap.sh` script from the root of this repo. This will
symlink all the dotfiles to your home directory, and install the apps in your
`.Brewfile` via Homebrew.

Note that this script is idempotent, so it's safe to run multiple times. If a
dotfile already exists it won't be symlinked, and if an application is already
installed it will be skipped:

```bash
# Bootstrap new environment
./bootstrap.sh
```

To _upgrade_ already installed applications, pass the `--upgrade` flag:

```bash
./bootstrap.sh --upgrade
```
