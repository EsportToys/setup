set jdk_url=https://download.oracle.com/java/21/latest/jdk-21_windows-x64_bin.zip
set pmc_url=https://github.com/fn2006/PollyMC/releases/download/8.0/PollyMC-Windows-MSVC-Portable-8.0.zip
(
    start "download jdk" cmd /c "curl --create-dirs -o Minecraft/jre/jdk.zip %jdk_url% -J -L && cd Minecraft/jre && tar -xf jdk.zip --strip-components=1 && del jdk.zip"
    start "download pmc" cmd /c "curl --create-dirs -o Minecraft/pmc.zip %pmc_url% -J -L && cd Minecraft && tar -xf pmc.zip && del pmc.zip && echo [General]>pollymc.cfg && echo JavaPath=jre/bin/javaw.exe>>pollymc.cfg"
) | pause
exit
