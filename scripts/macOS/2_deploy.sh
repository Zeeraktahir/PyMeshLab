#!/bin/bash

SCRIPTS_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

INSTALL_PATH=$SCRIPTS_PATH/../../pymeshlab
QT_DIR=""

#checking for parameters
for i in "$@"
do
case $i in
    -i=*|--install_path=*)
        INSTALL_PATH="${i#*=}"
        shift # past argument=value
        ;;
    -qt=*|--qt_dir=*)
        QT_DIR=${i#*=}/bin/
        shift # past argument=value
        ;;
    *)
        # unknown option
        ;;
esac
done

MODULE_NAME=$(find $INSTALL_PATH/dummybin.app/Contents  -name 'pmeshlab*')

ARGUMENTS=""

for plugin in $INSTALL_PATH/dummybin.app/Contents/PlugIns/*.so
do
    ARGUMENTS="${ARGUMENTS} -executable=${plugin}"
done

${QT_DIR}macdeployqt $INSTALL_PATH/dummybin.app \
    -executable=$MODULE_NAME \
    $ARGUMENTS

rsync -a $INSTALL_PATH/dummybin.app/Contents/Frameworks/ $INSTALL_PATH/Frameworks/
rsync -a $INSTALL_PATH/dummybin.app/Contents/PlugIns/ $INSTALL_PATH/PlugIns/
mv $INSTALL_PATH/dummybin.app/Contents/pmeshlab* $INSTALL_PATH/
rm -rf $INSTALL_PATH/dummybin.app
