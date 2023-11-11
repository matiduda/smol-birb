[![.github/workflows/create-github-release.yml](https://github.com/matiduda/smol-birb/actions/workflows/create-github-release.yml/badge.svg)](https://github.com/matiduda/smol-birb/actions/workflows/create-github-release.yml) [![.github/workflows/publish-game-to-itch-io.yml](https://github.com/matiduda/smol-birb/actions/workflows/publish-game-to-itch-io.yml/badge.svg)](https://github.com/matiduda/smol-birb/actions/workflows/publish-game-to-itch-io.yml)

## [Play on itch.io](https://tanczmy.itch.io/big-birb-run)

> Godot compatible version: **4.1.2**

# Project setup

1. Download [Godot 4.1.2](https://github.com/godotengine/godot/releases/download/4.1.2-stable/Godot_v4.1.2-stable_win64.exe.zip)
2. Install [VC Redist](https://learn.microsoft.com/en-GB/cpp/windows/latest-supported-vc-redist?view=msvc-170) (needed for Git plugin)
3. Install [Git for Windows](https://gitforwindows.org/)
4. Open Git Bash and configure your username and email
```
$ git config --global user.name "your name"
$ git config --global user.email your@email.com
```
5. Open the project in godot and go to Project > Version Control > Version Control Settings and put your github credentials there (SSH key not needed)
6. Go to Editor > Manage Export Templates > click Download and Install
7. Configure hooks using `git config --local core.hooksPath .githooks/`

8. You're ready to start developing features

## Code guidelines

- When adding new scenes, scripts or assets, adjust them to fit current structure
- Use [signals](https://www.youtube.com/watch?v=NK_SYVO7lMA) and build-in nodes and methods as ofter as you can

## Used assets

> Please keep up to date

- Game logo font https://www.dafont.com/m23-hydrant-special.font?fpp=200&text=SMOL+BIRB
