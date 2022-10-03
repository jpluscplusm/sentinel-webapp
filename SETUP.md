# Environment setup

## Debian Linux 11 (bullseye)

No released Debian version contains Python 3.10. Use whatever mechanism you prefer to install version 3.10.7, or greater. This method works:

1. Install pyenv (github.com/pyenv/pyenv) and integrate with your shell as documented in its repo
   - Make sure its shims are installed in your $PATH *before* your current Python
1. Install Python's build dependencies:
   - `sudo apt install libsqlite3-dev libffi-dev libreadline-dev libncurses-dev libbz2-dev liblzma-dev lzma-dev --no-install-suggests --no-install-recommends`
1. Install Python 3.10.7
   - `pyenv install 3.10.7`
1. Change into this repository’s directory
1. Enable Python 3.10.7
   - `pyenv local 3.10.7`
   - this will write the version into a .gitignored file; don’t unignore+commit this file. 
1. Install poetry with the new Python's pip3 installer
   - `pip3 install poetry`
   - 

(3.10.7 is the currently supported 3.10.x available on Heroku, where this app is running. Check https://devcenter.heroku.com/articles/python-support#supported-runtimes for updates to this)
