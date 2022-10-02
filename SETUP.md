# Environment setup

## Debian Linux 11 (bullseye)

No released Debian version contains Python 3.10. Use whatever mechanism you prefer to install version 3.10.2. This method works:

1. Install pyenv (github.com/pyenv/pyenv) and integrate with your shell as documented in its repo
   - Make sure its shims are installed in your $PATH *before* your current Python
1. Install Python's build dependencies:
   - `sudo apt install libsqlite3-dev libffi-dev libreadline-dev libncurses-dev libbz2-dev liblzma-dev lzma-dev --no-install-suggests --no-install-recommends`
1. Install Python 3.10.2
   - `pyenv install 3.10.2`
1. Install poetry with the new Python's pip3 installer
   - `pip3 install poetry`
