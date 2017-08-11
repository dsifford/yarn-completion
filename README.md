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

### Installation on OSX with Homebrew
```sh
$ brew install bash-completion
$ curl -L https://raw.githubusercontent.com/dsifford/yarn-completion/master/yarn-completion.bash > `brew --prefix`/etc/bash_completion.d/yarn
```
Restart `Terminal`

### Is your shell missing?

Open an issue with your shell and I'll do my best to try and make it happen.

## License

MIT
