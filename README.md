# .dotfiles-rewrite

Rewriting my dotfiles.

## Build

```bash
docker build -t dotfiles-container .
```

## Start

Attach project here:

```bash
docker run -dit \
  -v "$PWD:/dotfiles" \
  -v "$HOME/code/myproject:/workspace" \
  -w /workspace \
  -e WAYLAND_DISPLAY="$WAYLAND_DISPLAY" \
  -e XDG_RUNTIME_DIR=/tmp/xdg-runtime \
  -v "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/xdg-runtime/$WAYLAND_DISPLAY" \
  --name dotfiles-dev \
  dotfiles-container bash
```

## Edit

```bash
docker exec -it dotfiles-dev bash
```

In `nvim/`

```bash
./install.sh
```

## Stop

```bash
docker stop dotfiles-dev
docker rm dotfiles-dev
```
