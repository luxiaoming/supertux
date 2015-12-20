#!/bin/sh

ST_VERSION=`grep '^SET(SUPERTUX_VERSION' CMakeLists.txt | sed -e 's/SET(SUPERTUX_VERSION "\([^"]\+\)")/\1/'`
ST_VERSION=`git describe --tags | sed 's/^v//' | awk -F- '{print $1"-"$2;}'`
DISTDIR="supertux-$ST_VERSION"

if test -e "$DISTDIR"
then
	echo "$DISTDIR already exists."
	exit 1
fi

echo "Creating directory $DISTDIR"
mkdir "$DISTDIR" || exit 1

cp "CMakeLists.txt" "LICENSE.txt" "INSTALL.md" "README.md" "NEWS.md" "config.h.cmake" "makedist.sh" "makepot.sh" "supertux2.appdata.xml" "supertux2.desktop" "version.cmake" "version.cmake.in" "version.h.in" $DISTDIR
cp --parents mk/cmake/*.cmake $DISTDIR
cp --parents mk/msvc/* $DISTDIR

echo "Copying files:"
for DIR in contrib data docs man src tools external
do
	echo -n "  $DIR ... "
	find "$DIR" -type f -exec "cp" "--parents" "{}" "$DISTDIR" ";" -o -name .svn -prune
	echo "done"
done

echo -n "Creating $DISTDIR.tar.gz ... "
tar czf $DISTDIR.tar.gz $DISTDIR
echo "done"

echo -n "Creating $DISTDIR.tar.bz2 ... "
tar cjf $DISTDIR.tar.bz2 $DISTDIR
echo "done"

echo -n "Removing $DISTDIR ... "
rm -rf $DISTDIR
echo "done"
