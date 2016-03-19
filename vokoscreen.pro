TEMPLATE = app
TARGET = vokoscreen

# Input
HEADERS += screencast.h

SOURCES += main.cpp \
           screencast.cpp

FORMS += QvkNoPlayerDialog.ui
FORMS += vokoscreen.ui

# In der screencast.qrc stehen *.qm Einträge, diese Dateien sind aber noch nicht
# im Unterverzeichnis "language" vorhanden da diese "eigentlich" erst mit make geniert werden,
# daher gibt es eine Fehlermeldung wenn der Befehl qmake aufgerufen und "RESOURCES += screencast.qrc" abgearbeitet wird.
# Um der Fehlermeldung entgegenzuwirken das keine *.qm Dateien vorhanden sind wird lrelease als Systemaufruf vorher aufgerufen.
# Das Script/Macro siehe weiter unten "# language packages" muß weiter bestehen bleiben damit "make clean" die *.qm Dateien löscht.

equals(QT_MAJOR_VERSION, "4") {
  system(lrelease language/vokoscreen_*.ts)
  message("")
  message("[vokoscreen] lrelease --> qt4")
  message("")
}        

equals(QT_MAJOR_VERSION, "5") {
  system(lrelease-qt5 language/vokoscreen_*.ts)
  message("")
  message("[vokoscreen] lrelease --> qt5")
  message("")
}        

RESOURCES += screencast.qrc
                        
TRANSLATIONS = $$files(language/vokoscreen_*.ts)

# language packages

equals(QT_MAJOR_VERSION, "4") {
!isEmpty(TRANSLATIONS) {
  isEmpty(QMAKE_LRELEASE) {
    win32: QMAKE_LRELEASE = $$[QT_INSTALL_BINS]\lrelease.exe
      else: QMAKE_LRELEASE = $$[QT_INSTALL_BINS]/lrelease
  }
  isEmpty(TS_DIR):TS_DIR = language
  TSQM.name = lrelease ${QMAKE_FILE_IN}
  TSQM.input = TRANSLATIONS
  TSQM.output = $$TS_DIR/${QMAKE_FILE_BASE}.qm
  TSQM.commands = $$QMAKE_LRELEASE ${QMAKE_FILE_IN}
  TSQM.CONFIG = no_link 
  QMAKE_EXTRA_COMPILERS += TSQM
  PRE_TARGETDEPS += compiler_TSQM_make_all
}
  else: message(No translation files in project)
  message("")
  message("[vokoscreen] language packages --> qt4")
  message("")
}

equals(QT_MAJOR_VERSION, "5") {
!isEmpty(TRANSLATIONS) {
  isEmpty(QMAKE_LRELEASE) {
    win32: QMAKE_LRELEASE = $$[QT_INSTALL_BINS]\lrelease.exe
      else: QMAKE_LRELEASE = $$[QT_INSTALL_BINS]/lrelease-qt5
  }
  isEmpty(TS_DIR):TS_DIR = language
  TSQM.name = lrelease-qt5 ${QMAKE_FILE_IN}
  TSQM.input = TRANSLATIONS
  TSQM.output = $$TS_DIR/${QMAKE_FILE_BASE}.qm
  TSQM.commands = $$QMAKE_LRELEASE ${QMAKE_FILE_IN}
  TSQM.CONFIG = no_link 
  QMAKE_EXTRA_COMPILERS += TSQM
  PRE_TARGETDEPS += compiler_TSQM_make_all
}
  else: message(No translation files in project)
  message("")
  message("[vokoscreen] language packages --> qt5")
  message("")
}


# Install paths
isEmpty(PREFIX) {
    PREFIX = /usr
}

image.path = $$PREFIX/share/pixmaps
image.files += applications/vokoscreen.png
desktop.path = $$PREFIX/share/applications
desktop.files += applications/vokoscreen.desktop
man.path = $$PREFIX/share
man.files += man
target.path = $$PREFIX/bin

INSTALLS += target image desktop man

# Clean target
QMAKE_CLEAN += $$TARGET */*~

CONFIG += link_pkgconfig

# QtSingleApplication
equals(QT_MAJOR_VERSION, "4") {
  include(QtSingleApplicationQt4/qtsingleapplication.pri)
  message("")
  message("[vokoscreen] qtsingleapplication --> qt4")
  message("")
}

# QtSingleApplication
equals(QT_MAJOR_VERSION, "5") {
  include(QtSingleApplicationQt5/qtsingleapplication.pri)
  message("")
  message("[vokoscreen] qtsingleapplication --> qt5")
  message("")
}

# libqxt
equals(QT_MAJOR_VERSION, "4") {
include(libqxtQt4/libqxt.pri)
}

# libqxt
equals(QT_MAJOR_VERSION, "5") {
include(libqxtQt5/libqxt.pri)
}

# audio
include(audio/audio.pri)
PKGCONFIG += alsa

# send
include(send/send.pri)

# webcam
include(webcam/webcam.pri)
PKGCONFIG += libv4l2
PKGCONFIG += libv4lconvert

# settings
include(settings/settings.pri)

# showkey
include(showkey/showkey.pri)

# showclick
include(showclick/showclick.pri)

# magnifier
include(magnifier/magnifier.pri)

# credits
include(credits/credits.pri)

# version
include(version/version.pri)

# winInfo
include(winInfo/winInfo.pri)

# region
include(region/regionselection.pri)

# formatsAndCodecs
include(formatsAndCodecs/formatsAndCodecs.pri)

# countdown
include(countdown/countdown.pri)

# pulse
include(pulse/pulse.pri)

# log
equals(QT_MAJOR_VERSION, "5") {
include(log/log.pri)
  message("")
  message("[vokoscreen] log --> qt5")
  message("")
}

equals(QT_MAJOR_VERSION, "4") {
  DEFINES += QT4
  QT += testlib
  message("")
  message("[vokoscreen] Makefile --> qt4")
  message("")
}

equals(QT_MAJOR_VERSION, "5") {
  DEFINES += QT5
  QT += core gui widgets x11extras network testlib
  message("")
  message("[vokoscreen] Makefile --> qt5")
  message("")
}


