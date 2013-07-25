CHROME=/opt/google/chrome/chrome

TARGETS = menu docs hangouts music store helper

MENU_FILES = \
  js/const.js \
  js/app.js \
  js/menu-app.js \
  js/define.js \
  js/util.js \
  js/additional-effects.js \
  js/editor.js \
  js/edit-distance.js \
  js/words.js \
  css/common.css \
  css/menu-app.css \
  css/docs-app.css \
  css/hangouts-app.css \
  css/music-app.css \
  assets/menu-logo-2x.png \
  assets/docs-icon-64.png \
  assets/hangouts-icon-64.png \
  assets/music-icon-64.png \
  assets/store-icon-64.png \
  assets/docs-icon-128.png \
  assets/hangouts-icon-128.png \
  assets/music-icon-128.png \
  assets/store-icon-128.png \
  views/menu-app.html \
  gen/third-party/glfx.js \
  gen/third-party/effects.js \
  gen/third-party/track.js \
  third-party/ccv/js/ccv.js \
  third-party/ccv/js/face.js \
  third-party/open-sans/OpenSans-Light.ttf \
  third-party/open-sans/OpenSans-Regular.ttf

DOCS_FILES = \
  js/const.js \
  js/app.js \
  js/docs-app.js \
  js/util.js \
  css/common.css \
  css/docs-app.css \
  assets/docs-icon-32.png \
  assets/docs-icon-48.png \
  assets/docs-icon-64.png \
  assets/docs-icon-96.png \
  assets/docs-icon-128.png \
  views/docs-app.html \
  third-party/open-sans/OpenSans-Light.ttf \
  third-party/open-sans/OpenSans-Regular.ttf

HANGOUTS_FILES = \
  js/const.js \
  js/app.js \
  js/hangouts-app.js \
  js/util.js \
  css/common.css \
  css/hangouts-app.css \
  assets/hangouts-icon-32.png \
  assets/hangouts-icon-48.png \
  assets/hangouts-icon-64.png \
  assets/hangouts-icon-96.png \
  assets/hangouts-icon-128.png \
  assets/hangouts-section-group-2x.png \
  assets/hangouts-section-everywhere-2x.png \
  assets/hangouts-section-fun-2x.png \
  assets/hangouts-button-add-2x.png \
  assets/hangouts-button-effects-2x.png \
  assets/hangouts-button-invite-2x.png \
  assets/hangouts-button-screenshare-2x.png \
  assets/balloon-triangle-top.png \
  assets/balloon-triangle-bottom.png \
  views/hangouts-app.html \
  third-party/open-sans/OpenSans-Light.ttf \
  third-party/open-sans/OpenSans-Regular.ttf

MUSIC_FILES = \
  js/const.js \
  js/app.js \
  js/music-app.js \
  js/util.js \
  css/common.css \
  css/music-app.css \
  assets/music-icon-32.png \
  assets/music-icon-48.png \
  assets/music-icon-64.png \
  assets/music-icon-96.png \
  assets/music-icon-128.png \
  assets/music-section-anywhere-2x.png \
  assets/music-section-upload-2x.png \
  assets/music-section-unlimited-2x.png \
  assets/balloon-triangle-left.png \
  assets/music-play-control-2x.png \
  assets/music-equalizer-2x.gif \
  views/music-app.html \
  third-party/open-sans/OpenSans-Light.ttf \
  third-party/open-sans/OpenSans-Regular.ttf \
  third-party/roboto/Roboto-Light.ttf \
  third-party/roboto/Roboto-ThinItalic.ttf \
  third-party/music/sample-song.mp3

STORE_FILES= \
  js/const.js \
  js/app.js \
  js/store-app.js \
  js/util.js \
  css/common.css \
  css/store-app.css \
  assets/store-icon-32.png \
  assets/store-icon-48.png \
  assets/store-icon-64.png \
  assets/store-icon-96.png \
  assets/store-icon-128.png \
  assets/store-app.png \
  assets/store-app-top.png \
  assets/store-section-thousands-2x.png \
  assets/store-section-offline-2x.png \
  assets/store-section-install-2x.png \
  views/store-app.html \
  third-party/open-sans/OpenSans-Light.ttf \
  third-party/open-sans/OpenSans-Regular.ttf

HELPER_FILES= \
  js/const.js \
  js/helper-extension.js \
  js/util.js

packages: third-party
	for x in ${TARGETS}; \
	  do mkdir -p packages/demo-$$x; \
	  cp manifests/$$x-manifest.json packages/demo-$$x/manifest.json; \
	done
	cp ${MENU_FILES} packages/demo-menu
	cp ${DOCS_FILES} packages/demo-docs
	cp ${HANGOUTS_FILES} packages/demo-hangouts
	cp ${MUSIC_FILES} packages/demo-music
	cp ${STORE_FILES} packages/demo-store
	cp ${HELPER_FILES} packages/demo-helper
	for x in menu hangouts music store; \
	  do mkdir -p packages/demo-$$x/_locales; \
	     cp -r locales/$$x-locales/* packages/demo-$$x/_locales; \
	done

third-party:
	mkdir -p gen/third-party
	cp third-party/chrome-cam/src/chrome/libs/glfx/glfx.min.js \
	   gen/third-party/glfx.js
	cd gen/third-party && patch -p0 < ../../patches/glfx.patch
	coffee -o gen/third-party -c \
	  third-party/chrome-cam/src/chrome/scripts/effects/effects.coffee \
	  third-party/chrome-cam/src/chrome/scripts/face/track.coffee
	cd gen/third-party && patch -p0 < ../../patches/effects.patch

crx: packages
	for x in ${TARGETS}; \
	  do ${CHROME} --pack-extension=packages/demo-$$x \
		       --pack-extension-key=packages/demo-$$x.pem; \
	done

zip: packages
	for x in ${TARGETS}; \
	  do script/remove-entry packages/demo-$$x/manifest.json key; \
	     zip -r packages/demo-$$x.zip packages/demo-$$x; \
	done

.PHONY: packages crx zip third-party
