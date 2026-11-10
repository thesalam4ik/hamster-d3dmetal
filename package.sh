#!/bin/sh
# package.sh LIB VERSION: pack a Game Porting Toolkit `redist/lib` folder (external/ and wine/) for
# Hamster Launcher's downloader into dist/:
#   d3dmetal-<version>.tar.xz   d3dmetal-<version>/lib (the folder as it is) and Apple's License.pdf
#   package.json                version, file name, SHA-256 and size of that archive
# Nothing is built or changed: the files are Apple's. The script refuses a folder whose D3DMetal is
# not signed by Apple, so a release can only carry Apple's own binaries.
set -eu
[ $# -eq 2 ] || { echo "usage: $0 <redist/lib folder> <version>" >&2; exit 2; }
LIB=$1 VERSION=$2
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
for item in external/libd3dshared.dylib external/D3DMetal.framework; do
  codesign --verify --strict "$LIB/$item" || { echo "package: $item has no valid signature" >&2; exit 1; }
  codesign -dv --verbose=2 "$LIB/$item" 2>&1 | grep -q '^Authority=Software Signing$' ||
    { echo "package: $item is not signed by Apple" >&2; exit 1; }
done
for file in wine/x86_64-windows/d3d11.dll wine/x86_64-windows/d3d12.dll wine/x86_64-windows/dxgi.dll wine/x86_64-unix/d3d11.so; do
  [ -e "$LIB/$file" ] || { echo "package: $LIB has no $file" >&2; exit 1; }
done
NAME="d3dmetal-$VERSION"
OUT="$HERE/dist"
STAGE=$(mktemp -d)
trap 'rm -rf "$STAGE"' EXIT
mkdir -p "$OUT" "$STAGE/$NAME"
ditto "$LIB" "$STAGE/$NAME/lib"   # keeps the symbolic links and signatures as Apple made them
cp "$HERE/License.pdf" "$STAGE/$NAME/"
COPYFILE_DISABLE=1 tar -cJf "$OUT/$NAME.tar.xz" --no-xattrs --options 'xz:threads=0' -C "$STAGE" "$NAME"
printf '{ "version": "%s", "file": "%s.tar.xz", "sha256": "%s", "size": %s }\n' \
  "$VERSION" "$NAME" "$(shasum -a 256 "$OUT/$NAME.tar.xz" | cut -d ' ' -f 1)" "$(stat -f %z "$OUT/$NAME.tar.xz")" > "$OUT/package.json"
cat "$OUT/package.json"
