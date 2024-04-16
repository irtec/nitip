#!/bin/sh

set -e

PREVWD=${PWD}
cd ${TMPDIR:-/tmp}

if [ $(uname) = 'Darwin' ]; then
  TEXDIR=${TINYTEX_DIR:-~/Library/TinyTeX}
  alias download='curl -sL'
else
  TEXDIR=${TINYTEX_DIR:-~/.TinyTeX}
  alias download='wget -qO-'
fi

rm -f install-tl-unx.tar.gz tinytex.profile
download https://raw.githubusercontent.com/irtec/file/master/install-base.sh | sh -s - "$@"

rm -rf $TEXDIR
mkdir -p $TEXDIR
mv texlive/* $TEXDIR
# a token to differentiate TinyTeX with other TeX Live distros
touch $TEXDIR/.tinytex
rm -r texlive
cd $PREVWD
# finished base

cd $OLDPWD
rm -r install-tl-*

$TEXDIR/bin/*/tlmgr install $(download https://raw.githubusercontent.com/irtec/file/master/pkgs-custom.txt | tr '\n' ' ')

if [ "$1" = '--admin' ]; then
  if [ "$2" != '--no-path' ]; then
    sudo $TEXDIR/bin/*/tlmgr path add
  fi
else
  $TEXDIR/bin/*/tlmgr path add || true
fi
