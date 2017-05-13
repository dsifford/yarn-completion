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

**`zsh`** (currently partially supported)
```sh
$ echo "
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
. ~/.yarn-completion" >> ~/.zshrc
```

### Installation on OSX with Homebrew
```sh
$ brew install bash-completion
$ curl -L https://raw.githubusercontent.com/dsifford/yarn-completion/master/yarn-completion.bash > `brew --prefix`/etc/bash_completion.d/yarn
```
Restart `Terminal`


## License

MIT
