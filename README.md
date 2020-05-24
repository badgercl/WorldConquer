# World Conquer Game

Swift implementation based on [World War Bot's rules](https://worldwarbot.com/about/).


# Requirements
* Swift 5.2.2+ installed in your macOS or Linux machine. 

# Installing swift
1. For macOS users, it comes included with Xcode, you can download from the App Store:
1. For linux users, follow the instructions in https://swift.org/download/#using-downloads. 
1. For windows users: there are some solutions, but don't have a machine to try them out 🤷🏽‍♂️

# Developer environment
1. macOS: use Xcode 🚀
1. Linux: you can also have nice dev environments, please check 
  * [Develop Server side Swift on Linux](https://medium.com/@joscdk/develop-server-side-swift-on-linux-a9ea56e805cc)
  * [vim-swift](https://github.com/toyamarinyon/vim-swift)

# Running the game
You can get the latest available commands by runing `swift run WorldConquerApp -h`

For instance, for running a game using the provided Earth map and see the output in the console you can run the following command from the root level
```bash
swift run WorldConquerApp --json worlds/earth.json --verbose
```
