[![.github/workflows/create-github-release.yml](https://github.com/matiduda/big-birb-run/actions/workflows/create-github-release.yml/badge.svg)](https://github.com/matiduda/big-birb-run/actions/workflows/create-github-release.yml) [![.github/workflows/publish-game-to-itch-io.yml](https://github.com/matiduda/big-birb-run/actions/workflows/publish-game-to-itch-io.yml/badge.svg)](https://github.com/matiduda/big-birb-run/actions/workflows/publish-game-to-itch-io.yml)

> Godot compatible version: **4.1.2**

# Project setup

1. Download [Godot 4.1.2](https://github.com/godotengine/godot/releases/download/4.1.2-stable/Godot_v4.1.2-stable_win64.exe.zip)
1. Install [VC Redist](https://learn.microsoft.com/en-GB/cpp/windows/latest-supported-vc-redist?view=msvc-170) (needed for Git plugin)
2. Install [Git for Windows](https://gitforwindows.org/)
3. Open Git Bash and configure your username and email
```
$ git config --global user.name "your name"
$ git config --global user.email your@email.com
```
4. Open the project in godot and go to Project > Version Control > Version Control Settings and put your github credentials there (SSH key not needed)
5. Go to Editor > Manage Export Templates > click Download and Install
6. You're ready to start developing features
