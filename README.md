# .dotfiles-rewrite

Rewriting my dotfiles.

## Running

```bash
docker build -t dotfiles-test .
```

```bash
docker run --rm -it \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/dotfiles" \
  -w /dotfiles \
  -e HOME=/tmp \
  -e WAYLAND_DISPLAY="$WAYLAND_DISPLAY" \
  -e XDG_RUNTIME_DIR=/tmp/xdg-runtime \
  -v "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/xdg-runtime/$WAYLAND_DISPLAY" \
  dotfiles-test
```
