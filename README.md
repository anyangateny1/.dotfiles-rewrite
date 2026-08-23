# .dotfiles-rewrite

Rewriting my dotfiles.

## Running

```bash
docker build -t dotfiles-test .
```

```bash
  -v "$PWD:/dotfiles" \
  -w /dotfiles \
  -e WAYLAND_DISPLAY="$WAYLAND_DISPLAY" \
  -e XDG_RUNTIME_DIR=/tmp/xdg-runtime \
  -v "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/xdg-runtime/$WAYLAND_DISPLAY" \
  dotfiles-test
```
