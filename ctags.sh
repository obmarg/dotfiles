#!/bin/bash

ctags -R -f ./.pythontags `python -c "from distutils.sysconfig import get_python_lib; print get_python_lib()"`
