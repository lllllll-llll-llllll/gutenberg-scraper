;#include<array.au3>
;#include<file.au3>

;startup
global $book_id  = int(iniread('config.ini', 'settings', 'place', -1))
global $language =     iniread('config.ini', 'settings', 'language', 'English')
global $path     =     iniread('config.ini', 'settings', 'path', @scriptdir)
global $notify   = int(iniread('config.ini', 'settings', 'notify', true))
global $delay    = int(iniread('config.ini', 'settings', 'delay', 600))

;quick checks
tests()

while true
   $book_id = check($book_id)
   wait_sec($delay)
wend


func check($number); book id
   $id = $number
   $html = download($id)

   ;valid book id?
   $status = check_available($html)
   if not $status then return $id
   $id += 1

   ;book in target language?
   if $language <> '' then
	  $status = check_english($html)
	  if not $status then return $id
   endif

   ;html version? - download it
   $status = check_html($html)
   if not $status then return $id

   IniWrite('config.ini', 'settings', 'place', $book_id)
   if $notify then msgbox(0,'new english ebook downloaded', '', 60)

   return $id
endfunc


func download($number); book id
   filedelete('gutenberg.txt')
   $url = 'https://www.gutenberg.org/ebooks/' & $number
   $download = InetGet($url, 'gutenberg.txt')

   return FileReadToArray('gutenberg.txt')
endfunc


func check_available($array); html array
   if not fileexists('gutenberg.txt') then return false

   return true
endfunc


func check_english($array); html array
   for $i = 0 to ubound($array) - 1
	  if $array[$i] = '<td>' & $language & '</td>' then return true
   next

   return false
endfunc


func check_html($array); html array
   $line = 0
   for $i = 0 to ubound($array) - 1
	  if StringInStr($array[$i], 'Read this book online: HTML') then $line = $i
   next

   if $line = 0 then return false

   $string = $array[$line]
   $regex = stringregexp($string, 'href="(\/files.*?\.htm)" type="text', 3)
   $url = 'https://www.gutenberg.org' & $regex[0]
   inetget($url, $path & $book_id & '.htm')

   return true
endfunc




func wait_sec($seconds)
   sleep(1000 * $seconds)
endfunc




func tests()
   if $path = 'C:\Users\User\ExampleFolder\' or $path = '' then
	  msgbox(0, 'config.ini error', '[path] invalid - set a path for the ebooks to be downloaded to.')
	  exit
   endif

   if ($book_id < 1) then
	  msgbox(0, 'config.ini error', '[place] invalid - set a starting book id.')
	  exit
   endif

   if ($delay < 1) then
	  msgbox(0, 'config.ini error', '[delay] invalid - set amount of seconds to wait in between ebook downloads.')
	  exit
   endif

   if ($notify < 0) or ($notify > 1) then
	  msgbox(0, 'config.ini error', '[notify] invalid - set to 0 to disable message, 1 to enable.')
	  exit
   endif




endfunc























