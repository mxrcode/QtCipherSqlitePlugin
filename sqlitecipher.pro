TARGET = sqlitecipher

android {
    TEMPLATE = app
} else {
    TEMPLATE = lib
}

QT += core core-private sql sql-private
QT_FOR_CONFIG += sqldrivers-private

CONFIG += c++11 plugin

include($$PWD/src/sqlite3/sqlite3.pri)

target.path = $$[QT_INSTALL_PLUGINS]/sqldrivers/
INSTALLS += target

HEADERS  += \
    $$PWD/src/sqlitecipher_p.h \
    $$PWD/src/sqlitecipher_global.h

SOURCES  += \
    $$PWD/src/main.cpp \
    $$PWD/src/sqlitecipher.cpp

OTHER_FILES += $$PWD/src/SqliteCipherDriverPlugin.json

!system-sqlite:!contains( LIBS, .*sqlite.* ) {
    CONFIG(release, debug|release):DEFINES *= NDEBUG
    DEFINES += SQLITE_OMIT_LOAD_EXTENSION \
               SQLITE_OMIT_COMPLETE \
               SQLITE_ENABLE_FTS3 \
               SQLITE_ENABLE_FTS3_PARENTHESIS \
               SQLITE_ENABLE_RTREE \
               SQLITE_USER_AUTHENTICATION
    !contains(CONFIG, largefile):DEFINES += SQLITE_DISABLE_LFS
    winrt: DEFINES += SQLITE_OS_WINRT
    winphone: DEFINES += SQLITE_WIN32_FILEMAPPING_API=1
    qnx: DEFINES += _QNX_SOURCE
} else {
    LIBS += $$QT_LFLAGS_SQLITE
    QMAKE_CXXFLAGS *= $$QT_CFLAGS_SQLITE
}

PLUGIN_CLASS_NAME = SqliteCipherDriverPlugin
PLUGIN_TYPE = sqldrivers

DEFINES += QT_NO_CAST_TO_ASCII QT_NO_CAST_FROM_ASCII

QMAKE_CFLAGS += -march=native
