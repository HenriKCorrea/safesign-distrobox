# SafeSign Distrobox

A [distrobox](https://github.com/89luca89/distrobox) setup that runs [SafeSign Identity Client](https://www.serpro.gov.br/links-fixos-superiores/pss-serpro/drivers_token) inside an Ubuntu 20.04 container with a pre-configured Firefox profile, allowing you to use smart card authentication on Linux without modifying your host system.

## What it does

1. Creates a distrobox container (`safesign`) based on Ubuntu 20.04.
2. Installs required smart card dependencies (`libpcsclite1`, `pcscd`, etc.) and Firefox inside the container.
3. Downloads and installs **SafeSign IC Standard Linux 3.7.0.0** directly into the container.
4. Mounts the host's `pcscd` socket (`/run/pcscd/`) so the container can communicate with smart card readers connected to the host.
5. Creates a dedicated Firefox profile with the SafeSign PKCS#11 security module (`libaetpkss.so`) registered via `modutil`.
6. Sets a custom Firefox icon to distinguish the containerized instance from any native Firefox on the host.
7. Exports the configured Firefox app to the host desktop via `distrobox-export`.

## Prerequisites

- [distrobox](https://github.com/89luca89/distrobox) installed on the host.
- `pcscd` (PC/SC daemon) running on the host so smart card readers are accessible.
- A smart card reader with a compatible token (e.g., Serpro e-CPF/e-CNPJ tokens).

## Usage

### 1. Create and start the container

```bash
distrobox assemble create --file distrobox.ini
```

This will pull Ubuntu 20.04, install all required packages, and install SafeSign IC automatically.

### 2. Run the post-initialization script

Enter the container and run the post-init script:

```bash
distrobox enter safesign
./post_init.sh
```

This script:
- Creates a Firefox profile at `~/.distrobox/safesign/firefox`.
- Registers the SafeSign PKCS#11 module into that profile.
- Sets a custom icon for the exported Firefox app.
- Exports Firefox with `--no-remote --profile <profile-path>` flags so it launches with the correct profile.

### 3. Launch Firefox

After the setup, a Firefox entry should appear in your application launcher (or `~/.local/share/applications/`). Launch it to access sites that require smart card authentication.

## SafeSign driver

The SafeSign IC package is downloaded automatically from this repository during container setup.

- Serpro driver page: https://www.serpro.gov.br/links-fixos-superiores/pss-serpro/drivers_token
- Serpro direct download: https://serprodrive.serpro.gov.br/s/LEAqk2QYdL6RWDP
