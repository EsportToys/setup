set mono=https://dtinth.github.io/comic-mono-font/ComicMono.ttf
set bold=https://dtinth.github.io/comic-mono-font/ComicMono-Bold.ttf
curl %mono% --output font/ComicMono.ttf --create-dirs %bold% --output font/ComicMono-Bold.ttf --create-dirs
explorer.exe .\font