# yarn-completion

> Shell autocompletion for [Yarn](https://github.com/yarnpkg/yarn)

## Installation

1. Download the completion file to your machine.

```sh
$ curl -o ~/.yarn-completion https://raw.githubusercontent.com/dsifford/yarn-completion/master/yarn-completion.bash
```

2. Source the file in your shell `rc` file.

**`bash`**
```sh
$ echo -e '\n. ~/.yarn-completion' >> ~/.bashrc
```

**`zsh`**: Official zsh completions can be found in the [zsh-completions](https://github.com/zsh-users/zsh-completions/blob/master/src/_yarn) repository.

### Installation on macOS with Homebrew

1.  `bash` version >= 4.x.x is required, rather MacOS's default (and dated) bash v3.

    ```bash
    brew install bash
    ## restart terminal

    bash --version
    ## GNU bash, version 4.x = OK
    ```

2.  Install `bash-completion` if you have not done it yet:
    ```bash
    brew install bash-completion
    ## + copy one line to ~/.bash_profile as instructed by brew after bash-completion setup
    ```

3.  Install `yarn-completion`:
    ```sh
    curl -L https://raw.githubusercontent.com/dsifford/yarn-completion/master/yarn-completion.bash > `brew --prefix`/etc/bash_completion.d/yarn
    ```

4.  Restart Terminal.

## License

MIT
