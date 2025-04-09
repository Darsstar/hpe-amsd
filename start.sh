#!/bin/bash
set -euxo pipefail

# For all these commands:
# -f: Do not fork() from the calling shell.
# -L: Do not open a log file; print all messages to stderr.
/sbin/ahslog -f &
/sbin/smad &
sleep 1
/sbin/amsd -f -L &
sleep 1
/sbin/cpqIde -f -L &
/sbin/cpqiScsi -f -L &
sleep 1
wait
