#!/usr/bin/env bash

set -euxo pipefail

bazel test //test:twirl-compiler-test-2-13
bazel test //test:twirl-compiler-test-2-13-play-2-7
bazel test //test:twirl-compiler-test-3
