#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function gha_repack () {
  local REPO_DIR="$(readlink -m -- "$BASH_SOURCE"/../..)"
  local LIBS="$REPO_DIR"/build/libs
  cd -- "$LIBS" || return $?
  local ITEM= JAR=
  for ITEM in mousewheelie-*.jar; do
    [[ "$ITEM" == *source* ]] && continue
    [ -z "$JAR" ] || return 4$(
      echo "E: Cannot decide between '$JAR' and '$ITEM'" >&2)
    JAR="$ITEM"
  done
  [ -f "$JAR" ] || return 4$(echo "E: Found no qualified JAR" >&2)
  echo "jar_name=$JAR" >>"$GITHUB_OUTPUT"

  local DEST="$REPO_DIR"/jar-unpacked
  mkdir --parents -- "$DEST" || return $?
  cd -- "$DEST" || return $?
  unzip -- "$LIBS/$JAR" || return $?
}


gha_repack "$@"; exit $?
