Yubikey Challenger for 1Password
================================

YKC1P is an Applescript application that allows you to access to your 1Password vault using a memorized PIN and a Yubikey in challenge-response mode.

## Preparing

* Use the yubikey personalization tool to configure a slot in HMAC-SHA1 challenge response mode. Copy your secret if you want to have another key with it or if you'll save it in a secure location just in case.
* The password that you need to set in 1password as master secret is the result of sending your chosen PIN (can be alphanumeric) to the key, you can do this by doing: `ykchalresp -1 myPin` from the terminal. the number one in that command indicates the target slot. Remember to touch the key to get a reponse if needed.
* Go change the password in 1P to the response.
* CLEAN YOUR TERMINAL HISTORY to avoid leaking your PIN.

## Installing

I have only tried this on Mavericks with 1Password 4.

_Make sure you have installed ykpers. If you don't have it you can do this:

```
brew update
brew install ykpers
```

* Make sure you have 1Password mini enabled in your menu bar.
* Download the application in dist and put in your Applications folder
* Open it and it'll most likely fail on the first run.
* In System Preferences > Security & Privacy > Accessibility, enable YKC1P to control your machine. This is required in order for the GUI scripting to work.
* You can run the app again and it should ask you for the PIN and send the challenge to slot 1 of your inserted Yubikey.
* Touch the key to release the response (only if this was chosen on configuration)
* The script will use the response as master password and try to insert in the 1Password mini window. If the vault was open the mini dialog will be triggered and nothing will be done.

## Tips

* If you want slot1 to contain challenge response mode and slot2 to have the preinstalled yubikey credentials, you can swap them with `ykpersonalize -x`. This is perfect for a nano key.
* You can customize your key to use challenge response mode with "Yubikey Personalization Tool" for OS X. You can get it from [Yubico's personalization tools](http://www.yubico.com/products/services-software/personalization-tools/use/)

## Important notes

I made this in one day for my personal use, so it makes some assumptions:

* You can ensure your master secret is available by saving a copy of it in a secure location like a safe or something. Alternatively you can save your Yubikeys secret and the PIN, this would allow you to install the same secret in another Yubikey or a piece of software and get your password by providing the exact same ping. Remember there's no way to restore your vault if your password is lost.
* Slot 1 is set in HMAC-SHA1 challenge response mode. I used this slot because that way when I accidentally touch my Yubikey Nano I don't see any input in the screen. If you want to use slot 2 you must edit the application script and change the challenge command options from `-2`to `-1`. To do this open the app with Automator.
* It's assumed that you must touch the key in order to sent the response back to the machine, I do this as a security measure to ensure that malware in my machine would still need human intervention to access the key. Because of this assumption you'll see a notification as a reminder in your screen right after you enter your pin.
* Ideally you should use Alfred2 or a custom shortcut to trigger this app so that you have an easy way to open your vault when required. I created a small alfred workflow that does exactly this, doing the same on your preferred tool should be trivial.
* I'm a total newbie to Applescript and Yubikeys in general, if you see important errors please let me know.


## Rationale

The notion of splitting your password in two componentts was already explained by Colby Aley in one of his articles where he proposes to put a big random password in one of your Yubikey slots using the static passwords mode. Having a new Yubikey at hand I wanted to make it a little harder for someone stealing my Yubikey to access the most complex part of my password. In order to achieve that this little script will allow you to send a memorized PIN to the Yubikey as a challenge and use the response as your 1Password master secret.

It's only a small detail on top of the static password idea in the sense that the response is always the same, this howevers makes the knowledge of the memorized part a prerequisite for the Yubikey to be any use. It also has another benefit (may seem a draback to most people I guess): You must have a client capable of challenging the Yubikey in order to use it as opposed to regular touch & go operation in the static password config.

Special thanks to the Colby Aley and Xavier Shay for inspiring me to create this:

[Replacing Google Authenticator with Yubikey on OSX](http://corner.squareup.com/2013/05/replacing-google-authenticator-with-yubikey-on-osx.html)
[I know none of my passwords.](http://aley.me/passwords)

Copyright note: I've taken the Yubicon.icns from the OS X personalization tool app, I suppose Yubico will not matter but should you own any rights on that icon and want me to take it down, please let me know ;)

This is licensed under MIT without any warranties, please use it at your own risk.