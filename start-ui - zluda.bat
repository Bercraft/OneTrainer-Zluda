@echo off

set HSA_XNACK=1
 
set FLASH_ATTENTION_TRITON_AMD_ENABLE=TRUE
set FLASH_ATTENTION_TRITON_AMD_AUTOTUNE=TRUE

set MIOPEN_FIND_MODE=2
set MIOPEN_LOG_LEVEL=3

set ZLUDA_COMGR_LOG_LEVEL=1

set PYTHON="%~dp0/venv/Scripts/python.exe"
set VENV_DIR=./venv

set COMMANDLINE_ARGS=-m scalene --off --cpu --gpu --profile-all --no-browser

echo Using Python %PYTHON%
echo.
echo Starting UI...
.\zluda\zluda.exe -- %PYTHON% scripts\train_ui.py %COMMANDLINE_ARGS%
pause