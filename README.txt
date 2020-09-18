this autoit script will periodically check for new gutenberg ebooks, by default it is set to grab english books.
by default this delay is slow enough in between checks (10 minutes) to not get your ip flagged, reduce the delay at your own risk.


instructions:
make sure "gutenberg-scraper.au3" and "config.ini" are in the same folder
you need to check the values in "config.ini":
  place=63231 [integer; the starting gutenberg book id to begin seaching from.]
  language=English [string; the language you want to download. leave empty to download all languages.]
  path=C:\Users\User\Desktop\ [string; this is the path to download the ebooks to.]
  notify=1 [integer; 1 to enable a simple notification on every new download, 0 to not.]
  delay=600 [integer; amount of seconds to wait in between checking for new ebooks.]
run the script and forget about it. if you close it or it somehow crashes you can just restart it, it saves its position.
