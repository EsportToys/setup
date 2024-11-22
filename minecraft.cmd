set jdk_url=https://download.oracle.com/java/21/latest/jdk-21_windows-x64_bin.zip
set pmc_url=https://github.com/fn2006/PollyMC/releases/download/8.0/PollyMC-Windows-MSVC-Portable-8.0.zip
(
    start "download jdk" cmd /C "curl --create-dirs -o Minecraft/jre/jdk.zip %jdk_url% -J -L && tar -xf Minecraft/jre/jdk.zip --strip-components=1 --directory=Minecraft/jre && del Minecraft\jre\jdk.zip"
    start "download pmc" cmd /C "curl --create-dirs -o Minecraft/pmc.zip %pmc_url% -J -L && tar -xf Minecraft/pmc.zip --directory=Minecraft && del Minecraft\pmc.zip"
) | pause
exit