on unlock_vault(pin)
	set masterpass to my challenge(pin)
	if my is_closed() then my toggle_mini()
	tell application "System Events" to tell process "1Password mini"
		keystroke masterpass
		keystroke return
	end tell
end unlock_vault

on is_locked()
	tell application "System Events" to tell process "1Password mini"
		set unlock_button to a reference to button "Unlock" of window 1
		if unlock_button exists then
			return true
		else
			return false
		end if
	end tell
end is_locked

on is_closed()
	tell application "System Events" to tell process "1Password mini"
		if (window 1) exists then
			return false
		else
			return true
		end if
	end tell
end is_closed

on toggle_mini()
	tell application "System Events" to tell process "1Password mini"
		click menu bar item 1 of menu bar 1
	end tell
end toggle_mini

on challenge(chal)
	set ykcmd to "/opt/boxen/homebrew/bin/ykchalresp -1 " & chal
	set msg to "Please touch your Yubikey for the challenge response to be sent back to the requester."
	display notification msg with title "Yubikey touch required"
	delay 0.1 -- give time to the notification
	set master to (do shell script ykcmd)
	return master
end challenge

on icon()
	-- takes yubikey icon from the personalization tool
	set ykicon to "/Applications/YubiKey Personalization Tool.app/Contents/Resources/Yubico.icns"
	return POSIX file ykicon as alias
end icon

on pin_handler()
	tell application "Alfred 2"
		activate
		set yubikeyIcon to my icon()
		try
			set dg to display dialog ¬
				¬
					"Please enter your Yubikey challenge PIN to proceed with the authentication:" with title "Yubikey challenge" buttons {"Cancel", "OK"} ¬
				default button "OK" default answer ¬
				"" with icon yubikeyIcon with hidden answer
			activate dg
			set pin to text returned of dg
			if pin is not equal to "" then my unlock_vault(pin)
		on error number -128
			return false
		end try
	end tell
end pin_handler

on run()
	if my is_closed() then my toggle_mini() -- open it if closed
	if my is_locked() then -- we must close it again for the pin dialog to appear
		my toggle_mini()
		my pin_handler()
	end if
end run