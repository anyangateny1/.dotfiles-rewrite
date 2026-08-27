# Tree-sitter

Tree sitter needs a version of rust running that command.
It also needs clang strangely enough.

commands like cargo instal x do not work due to sudo shell.

Missing cursor highlight, I think it's an LSP thing.

ripgrep and fd are much better than alternatives.

## Luarocks

```bash
wget https://luarocks.org/releases/luarocks-3.13.0.tar.gz
```

```bash
tar zxpf luarocks-3.13.0.tar.gz
```

```bash
cd luarocks-3.13.0
```

```bash
./configure && make && sudo make install
```

```bash
sudo luarocks install luasocket
```
