
REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CSC /f /v Start /t REG_DWORD /d 00000004
REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CSCService /f /v Start /t REG_DWORD /d 00000004

