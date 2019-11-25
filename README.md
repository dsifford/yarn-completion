# yarn-completion ![](https://github.com/dsifford/yarn-completion/workflows/build/badge.svg)

> Bash ^4.x completion for [Yarn](https://github.com/yarnpkg/yarn)

## Installation

To enable on-demand completion loading, download the completion file to the predefined bash-completion user directory.

```sh
$ curl -o "${BASH_COMPLETION_USER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion}/completions/yarn" https://raw.githubusercontent.com/dsifford/yarn-completion/master/yarn-completion.bash
```

### Installation on macOS with Homebrew

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

3.  Install `yarn-completion`:

    ```sh
    mkdir -p "${BASH_COMPLETION_USER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion}/completions"
    curl -o "${BASH_COMPLETION_USER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion}/completions/yarn" https://raw.githubusercontent.com/dsifford/yarn-completion/master/yarn-completion.bash
    ```

4.  Restart Terminal.

### Installation on Debian based Linux [Ubuntu/Mint/others]

Usually the completion files are installed under /etc/bash_completion.d when installing a package as *root*. However for user user completion a using the home folder would ensure portability in case of system reinstallation.

1.  Ensure that `bash` version ^4.x.x is **installed**. It should be by the default on any recent distribution. Check with:

    ```bash
    bash --version
    ```

2. Create a directory in your home folder to host the yarn completion: 

    ```bash
    mkdir $HOME/.config/yarn-completion/
    ```

3. Copy the `yarn-completion` from the repo in the created directory
    ```bash
    curl -o "$HOME/.config/yarn-completion/yarn" https://raw.githubusercontent.com/dsifford/yarn-completion/master/yarn-completion.bash
    ```

4. Create a custom completions launcher file if not already present `~/.bash_completion`


5. Add the reference to the yarn completion in the `~/.bash_completion` file
    ```bash
	# Yarn Completion 
	if [ -f ~/.config/yarn-completion/yarn ]; then 
		source ~/.config/yarn-completion/yarn 
	fi 
    ```
6. Restart the terminal or source the completion file to have it working without restart:

	```bash
	source ~/.bash_completion 
	```


## FAQ

> Will you support bash 3?

**No**. Bash 3 is now 9 years outdated (at time of writing). There is no conceivable reason why anybody would or should still be using bash 3. Upgrade to the latest version of bash.

> Completion fails for run scripts that contains a colon.

This is a feature of bash. Enable `menu-complete` in your `~/.inputrc` if you'd prefer a more seamless experience.

```
# Cycle through completions, rather than dumping all options
TAB:       menu-complete
"\e[Z":    menu-complete-backward
```

## License

MIT
