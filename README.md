# World Conquer Game

Swift implementation based on [World War Bot's rules](https://worldwarbot.com/about/).

# Features
## Current
- Can use any World configuration as a JSON file.
- Customizable rules: different winner and conquered territory implementation can be supported.
- Customizable output: the game status can be updated in different supports, e.g. Twitter, Telegram, console log, filesystem. (Currently only console output is provided).
- Dot-notation world states
- Internationalisation
- Telegram plugin

## Future work
- Twitter plugin
- Interactions with the bot

# Requirements
* Swift 5.3+ installed in your macOS or Linux machine. 

# Installing swift
1. For macOS users, it comes included with Xcode, you can download from the App Store:
1. For linux users, follow the instructions in https://swift.org/download/#using-downloads. 
1. For windows users: there are some solutions, but don't have a machine to try them out 🤷🏽‍♂️

# Developer environment
1. macOS: use Xcode 🚀
1. Linux: you can also have nice dev environments, please check 
  * [Develop Server side Swift on Linux](https://medium.com/@joscdk/develop-server-side-swift-on-linux-a9ea56e805cc)
  * [vim-swift](https://github.com/toyamarinyon/vim-swift)

# Running tests
* macOS and Linux: from the root level run `swift test`
* macOS + Xcode: cmd+U

# Running the game
You can get the latest available commands by runing `swift run WorldConquerApp -h`

For instance, to bootstrap a game using the provided Earth map and see the output in the console you can run the following command from the root level
```bash
swift run WorldConquerApp --json worlds/earth.json --console
```

and then every step is processed by calling
```bash
swift run WorldConquerApp --console
```

When a country has conquered the whole world, the game will output the winner and no more steps will be processd.
