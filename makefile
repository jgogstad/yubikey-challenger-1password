APP=YKC1P.app
TARGET_BUNDLE=dist/$(APP)
TARGET_ZIP=dist/YKC1P.zip
TARGET_ICON=$(TARGET_BUNDLE)/Contents/Resources/AutomatorApplet.icns
INSTALL_PATH=$$HOME/Applications/$(APP)

NORMAL=\x1b[0m
GREEN=\x1b[32;01m
RED=\x1b[31;01m
YELLOW=\x1b[33;01m

define log
    @echo "\n$(YELLOW)=> $1$(NORMAL)"
endef

build: clean copy name icon zip
	$(call log,"Build to ./dist complete")
	

clean:
	@echo "Building Yubikey Challenger for 1Password..."
	$(call log,"Cleaning and creating ./dist")
	if [[ -d dist ]]; then rm -fR dist; fi
	mkdir -p dist

copy:
	$(call log,"Copying base to $(TARGET_BUNDLE)")
	cp -r "src/ykc1p.app" "$(TARGET_BUNDLE)"

name:
	$(call log,"Changing bundle name to application")
	sed -i "" "s/com\.apple\.automator\.ykc1p/co\.vlipco\.ykc1p/g" "$(TARGET_BUNDLE)/Contents/Info.plist"
icon:
	$(call log,"Adding Yubikey icon to application")
	rm "$(TARGET_ICON)"
	cp "src/Yubikey.icns" "$(TARGET_ICON)"

zip:
	$(call log,"Compressing Application as zip package")
	zip -q -r "$(TARGET_ZIP)" "$(TARGET_BUNDLE)"

install: build
	$(call log,"Removing old version")
	rm -fR "$(INSTALL_PATH)"
	
	$(call log,"Installing fresh app")
	cp -r "$(TARGET_BUNDLE)" "$(INSTALL_PATH)"
	@echo "\n$(RED)IMPORTANT!$(NORMAL) Remember to enable the app in System Preferences > Security & Privacy > Accessibility"

launch:
	$(call log,"Launching application")
	open "$(INSTALL_PATH)"
