set love_url=https://github.com/love2d/love/releases/download/11.5/love-11.5-win64.zip
set sdl_url=https://github.com/libsdl-org/SDL/releases/download/release-2.30.9/SDL2-2.30.9-win32-x64.zip
(
    start "Downloading Love2D" cmd /c "curl --create-dirs -o love/love.zip %love_url% -J -L && tar -xf love/love.zip --strip-components=1 --directory=love && del love\love.zip"
    start "Downloading SDL" cmd /c "curl --create-dirs -o love/SDL2.zip %sdl_url% -J -L && tar -xf love/SDL2.zip --directory=love && del love\SDL2.zip"
) | pause
exit