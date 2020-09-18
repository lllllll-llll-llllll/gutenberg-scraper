#include<array.au3>
#include<file.au3>

;startup
global $book_id  = int(iniread('config.ini', 'settings', 'place', -1))
global $language =     iniread('config.ini', 'settings', 'language', 'English')
global $path     =     iniread('config.ini', 'settings', 'path', @scriptdir)
global $notify   = int(iniread('config.ini', 'settings', 'notify', true))
global $delay    = int(iniread('config.ini', 'settings', 'delay', 600))

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

   ;book in english?
   $status = check_english($html)
   if not $status then return $id

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




























