@echo off

title OneTrainer-Zluda Installer

set ZLUDA_COMGR_LOG_LEVEL=1
setlocal EnableDelayedExpansion
set "startTime=%time: =0%"

cls
echo ---------------------------------------------------------------
Echo * OneTrainer-ZLUDA INSTALL (for HIP 6.2.4 with MIOPEN and Triton)*
echo ---------------------------------------------------------------
echo.
echo  ::  %time:~0,8%  ::  - Setting up the virtual enviroment
Set "VIRTUAL_ENV=venv"
If Not Exist "%VIRTUAL_ENV%\Scripts\activate.bat" (
    python.exe -m venv %VIRTUAL_ENV%
)

If Not Exist "%VIRTUAL_ENV%\Scripts\activate.bat" Exit /B 1

echo  ::  %time:~0,8%  ::  - Virtual enviroment activation
Call "%VIRTUAL_ENV%\Scripts\activate.bat"
echo  ::  %time:~0,8%  ::  - Updating the pip package 
python.exe -m pip install --upgrade pip --quiet
echo.
echo  ::  %time:~0,8%  ::  Beginning installation ...
echo.
echo  ::  %time:~0,8%  ::  - Installing required packages
pip install -r requirements.txt --quiet
echo  ::  %time:~0,8%  ::  - Installing torch for AMD GPUs (First file is 2.7 GB, please be patient)
pip uninstall torch torchvision -y --quiet

pip install torch==2.7.0 torchvision==0.22.0 --index-url https://download.pytorch.org/whl/cu118 --quiet

echo  ::  %time:~0,8%  ::  - (temporary numpy fix)
pip uninstall numpy -y --quiet
pip install numpy==2.2.2 --quiet

echo  ::  %time:~0,8%  ::  - Python 3.11 detected, installing triton for 3.11

pip install triton-3.0.0+git2b248f14-cp311-cp311-win_amd64.whl --quiet

echo  ::  %time:~0,8%  ::  - Installing flash-attention

pip install flash_attn-2.7.4.post1-py3-none-any.whl --quiet


echo  ::  %time:~0,8%  ::  - Copy python libs
xcopy C:\Users\aless\AppData\Local\Programs\Python\Python311\libs venv\libs /s /e /i

echo  ::  %time:~0,8%  ::  - Patching ZLUDA
:: Download ZLUDA version 3.9.5 nightly
rmdir /S /Q zluda 2>nul
mkdir zluda
cd zluda
%SystemRoot%\system32\curl.exe -sL --ssl-no-revoke https://github.com/lshqqytiger/ZLUDA/releases/download/rel.5e717459179dc272b7d7d23391f0fad66c7459cf/ZLUDA-nightly-windows-rocm6-amd64.zip > zluda.zip
%SystemRoot%\system32\tar.exe -xf zluda.zip
del zluda.zip
cd ..
:: Patch DLLs
copy zluda\cublas.dll %VIRTUAL_ENV%\Lib\site-packages\torch\lib\cublas64_11.dll /y >NUL
copy zluda\cusparse.dll %VIRTUAL_ENV%\Lib\site-packages\torch\lib\cusparse64_11.dll /y >NUL
copy %VIRTUAL_ENV%\Lib\site-packages\torch\lib\nvrtc64_112_0.dll %VIRTUAL_ENV%\Lib\site-packages\torch\lib\nvrtc_cuda.dll /y >NUL
copy zluda\nvrtc.dll %VIRTUAL_ENV%\Lib\site-packages\torch\lib\nvrtc64_112_0.dll /y >NUL
copy zluda\cudnn.dll %VIRTUAL_ENV%\Lib\site-packages\torch\lib\cudnn64_9.dll /y >NUL
copy zluda\cufft.dll %VIRTUAL_ENV%\Lib\site-packages\torch\lib\cufft64_10.dll /y >NUL
copy zluda\cufftw.dll %VIRTUAL_ENV%\Lib\site-packages\torch\lib\cufftw64_10.dll /y >NUL

echo  ::  %time:~0,8%  ::  - ZLUDA 3.9.5 nightly patched for HIP SDK 6.2.4 with miopen and triton-flash attention.
echo. 
set "endTime=%time: =0%"
set "end=!endTime:%time:~8,1%=%%100)*100+1!"  &  set "start=!startTime:%time:~8,1%=%%100)*100+1!"
set /A "elap=((((10!end:%time:~2,1%=%%100)*60+1!%%100)-((((10!start:%time:~2,1%=%%100)*60+1!%%100), elap-=(elap>>31)*24*60*60*100"
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"
echo ..................................................... 
echo *** Installation is completed in %hh:~1%%time:~2,1%%mm:~1%%time:~2,1%%ss:~1%%time:~8,1%%cc:~1% . 
pause