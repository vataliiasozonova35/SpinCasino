#!/bin/bash

set -eo pipefail

cd SpinCasino-package; swift test --parallel; cd ..
