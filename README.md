# yarn-completion ![](https://github.com/dsifford/yarn-completion/workflows/build/badge.svg)

> Bash ^4.x completion for [Yarn](https://github.com/yarnpkg/yarn)

## Installation

To enable on-demand completion loading, download the completion file to the predefined bash-completion user directory.

```sh
mkdir -p "${BASH_COMPLETION_USER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion}/completions/"
curl -o "${BASH_COMPLETION_USER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion}/completions/yarn" \
	https://raw.githubusercontent.com/dsifford/yarn-completion/master/yarn-completion.bash
```

### Installation on macOS with Homebrew
To use this script on macOS, we need to install [bash](https://www.gnu.org/software/bash/) and [bash-completion](https://github.com/scop/bash-completion) in addition to the above script.

1.  `bash` version ^4.x.x is **required**.

    ```bash
    brew install bash

    # Add installed bash to /etc/shells
    sudo echo /usr/local/bin/bash >> /etc/shells
	# or
	echo /usr/local/bin/bash | sudo tee -a /etc/shells

    # Set installed bash as your default login shell
    chsh -s /usr/local/bin/bash
    ```

2.  Install `bash-completion@2` if you have not done it yet:

    ```bash
    brew install bash-completion@2
    ## + copy one line to ~/.bash_profile as instructed by brew after bash-completion setup
    ```

3.  Restart Terminal.

## FAQ

> Will you support bash 3?

**No**. Bash 3 is now 9 years outdated (at time of writing). There is no conceivable reason why anybody would or should still be using bash 3. Upgrade to the latest version of bash.

## License

MIT
