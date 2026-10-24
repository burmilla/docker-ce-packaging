# System Docker packaging

Builds the static System Docker tgz for BurmillaOS: `make ros-static-<arch>` with `<arch>` one of `amd64`, `arm64`, `loong64` or `riscv64`.
Any of them builds on any host, the CLI and engine cross compile when `<arch>` is not the host.
Driven by [os-system-docker](https://github.com/burmilla/os-system-docker).
