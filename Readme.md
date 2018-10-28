Fork of [vlipco-archive/yubikey-challenger-1password](https://github.com/vlipco-archive/yubikey-challenger-1password)

**Updates**

* Works with 1Password 7
* Removed manipulation of the TCC db in Makefile, it's read-only since Mojave. This means you manually need to re-add permissions under Accessibility in Security $ Privacy every time you do `make install`.

**Changes**

* After you press the button on your Yubikey, the master password is entered as keypress events. This enables you to enter your password to input fields (for instance on 1password.com), without copying it to the clipboard. Needless to say, having your master password on the clipboard makes it visible to all running processes, in addition to it being stored by any clipboard history tool.
* Updated documentation with more tips and slight adaptions for Mojave and 1Password 7

Yubikey Challenger for 1Password
================================

YKC1P is an Applescript application that allows you to access to your 1Password vault using a memorized PIN and a Yubikey in challenge-response mode.

## Preparing

* Use the yubikey personalization tool to configure a slot in HMAC-SHA1 challenge response mode. Use "Fixed 64 byte input" if you want to configure multiple keys.

* The password that you need to set in 1password as master secret is the result of sending your chosen PIN (can be alphanumeric) to the yubikey. You can do this by doing: `ykchalresp -1 myPin` from the terminal. The number one in that command indicates the target slot. Remember, if needed, to touch the key to get a reponse.

* Go change the password in 1Password to that large alphanumeric lowercase string.

* __CLEAN YOUR TERMINAL HISTORY to avoid leaking your PIN.__

  * ZSH tip: In order to avoid secrets leaking to your shell's history file, consider `setopt histignorespace` (command prefixed with a space is not added to history), and/or add the following function to your `.zshrc` to always ignore adding `ykchalresp` to history:

    ```
    function zshaddhistory() {
        emulate -L zsh
        if [[ $1 != "ykchalresp"* ]] ; then
            print -sr -- "${1%%$'\n'}"
            fc -p
        else
            return 1
        fi
      }
    ```


## Installing

Tested OK on macOS Mojave, 1Password 7

__Make sure you have installed ykpers.__ If you don't have it you can do this:

```
brew update
brew install ykpers
```

* Download the [latest version]() unzip and put the application __inside your Home's Applications folder. It won't work if you put it in the global Applications folder__.
* Open it and it'll tell you it can run because it lack permissions.
* In System Preferences > Security & Privacy > Accessibility, enable YKC1P to control your machine. __This is required in order for the GUI scripting to work.__ If the application isn't listed, drag it from the place you installed in Finder.
* You can run the app again and it should ask you for the PIN and send the challenge to slot 1 of your inserted Yubikey.
* Touch the key to release the response (only if this was chosen on configuration of your Yubikey).
* __The script will write the master password to whatever had focus before you invoked the script__

## Tips

* If you want slot1 to contain challenge response mode and slot2 to have the preinstalled yubikey credentials _(as this application asumes)_, you can swap them with `ykpersonalize -x` This is perfect for a nano key.
* You can customize your key to use challenge response mode with "Yubikey Personalization Tool" for macOS. You can get it from [Yubico's personalization tools](http://www.yubico.com/products/services-software/personalization-tools/use/) or `brew cask install yubico-yubikey-personalization-gui`
* Ideally you should __use an Alfred3 workflow with a custom shortcut to trigger this app so that you have an easy way to open your vault when required__. I created a small alfred workflow that does exactly this (tracked in the repo just in case), doing the same on your preferred tool should be trivial.

## How to edit the app

You can customize the app simply by editing the script in the src folder with Automator, saving and then running `make install` from the root of the repo. __This could be useful if for instance your `ykchalresp` binary isn't located in `/usr/local/bin/ykchalresp` or you don't want the challenge to be sent to slot #1__ I think editing the app is way simpler than creting a configuration file. Check the makefile for understanding what it does it's like 50 lines with a lot of whitespace!

## Important notes

__I made this in one day for my personal use, so it makes some assumptions:__

* You can ensure your master secret is available by saving a copy of it in a secure location like a safe or something. Alternatively you can save your Yubikeys secret and the PIN, this would allow you to install the same secret in another Yubikey or a piece of software and get your password by providing the exact same ping. _Remember there's no way to restore your vault if your password is lost._
* __Slot 1 is set in HMAC-SHA1 challenge response mode. I used this slot because that way when I accidentally touch my Yubikey Nano I don't see any input in the screen.__ If you want to use slot 2 you must edit the application script and change the challenge command options from `-2`to `-1`. To do this open the app with Automator.
* I'm a total newbie to Applescript and Yubikeys in general, if you see important errors please let me know.


## Rationale

The notion of splitting your password in two componentts was already explained by Colby Aley in one of his articles where he proposes to put a big random password in one of your Yubikey slots using the static passwords mode. Having a new Yubikey at hand I wanted to make it a little harder for someone stealing my Yubikey to access the most complex part of my password. In order to achieve that this little script will allow you to send a memorized PIN to the Yubikey as a challenge and use the response as your 1Password master secret.

It's only a small detail on top of the static password idea in the sense that the response is always the same, this howevers makes the knowledge of the memorized part a prerequisite for the Yubikey to be any use. It also has another benefit (may seem a draback to most people I guess): You must have a client capable of challenging the Yubikey in order to use it as opposed to regular touch & go operation in the static password config.

Special thanks to Colby Aley and Xavier Shay for inspiring me to create this:

* [Replacing Google Authenticator with Yubikey on OSX](http://corner.squareup.com/2013/05/replacing-google-authenticator-with-yubikey-on-osx.html)
* [I know none of my passwords.](http://aley.me/passwords)

Copyright note: I've taken the Yubicon.icns from the OS X personalization tool app, I suppose Yubico will not care. Nonetheless, should you own any rights on that icon and want me to take it down, please let me know :)

This is licensed under MIT without any warranties, please use it at your own risk.
