' functionLibrary test suite

global testnum, testok, testfailed

run "functionLibrary", #lib

call test "version()"
call assertn #lib version(), 7

call test "isnull()"
call assertn #lib isnull(), 0

call test "debug$()"
call assert #lib debug$(), "Function Library"

call test "adler32()"
call assertn #lib adler32(""), 1
call assertn #lib adler32("Hello World"), 403375133

call test "setPathSeparator()"
call assertn #lib setPathSeparator("|"), 0
call assertn #lib setPathSeparator("\"), 1
call assertn #lib setPathSeparator("/"), 1

call test "basename$()"
#lib setPathSeparator("/")
call assert #lib basename$("/path/to/a/file.ext"), "file.ext"
call assert #lib basename$("file.ext"), "file.ext"
#lib setPathSeparator("\")
call assert #lib basename$("c:\path\to\a\file.ext"), "file.ext"
call assert #lib basename$("c:file.ext"), "file.ext"
call assert #lib basename$("file.ext"), "file.ext"

call test "dirname$()"
#lib setPathSeparator("/")
call assert #lib dirname$("/path/to/a/file.ext"), "/path/to/a"
call assert #lib dirname$("file.ext"), "."
#lib setPathSeparator("\")
call assert #lib dirname$("c:\path\to\a\file.ext"), "c:\path\to\a"
call assert #lib dirname$("c:file.ext"), "c:."
call assert #lib dirname$("file.ext"), "."

call test "extension$()"
#lib setPathSeparator("/")
call assert #lib extension$("/path/to/a/file.ext"), "ext"
call assert #lib extension$("/path/to/a/file"), ""
call assert #lib extension$("/path/to.ext/file"), ""
#lib setPathSeparator("\")
call assert #lib extension$("c:\path\to\a\file.ext"), "ext"
call assert #lib extension$("\path\to\a\file"), ""
call assert #lib extension$("c:\path\to.ext\file"), ""

call test "PathSeparator$()"
#lib setPathSeparator("/")
call assert #lib pathSeparator$(), "/"
#lib setPathSeparator("\")
call assert #lib pathSeparator$(), "\"

call test "escapeHTML$()"
call assert #lib escapeHTML$("abcdefghijklmnopqrstuvwxyz"), "abcdefghijklmnopqrstuvwxyz"
call assert #lib escapeHTML$("ABCDEFGHIJKLMNOPQRSTUVWXYZ"), "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
call assert #lib escapeHTML$("0123456789-_.~"), "0123456789-_.~"
call assert #lib escapeHTML$("!#$&'()*+,/:;=?@[]<> "), "!#$&amp;&#39;()*+,/:;=?@[]&lt;&gt; "

call test "getPrefix$()"
call assert #lib getPrefix$("Hello world!", "apple"), ""
call assert #lib getPrefix$("Hello world!", "H"), ""
call assert #lib getPrefix$("Hello world!", "llo"), "He"
call assert #lib getPrefix$("Hello World!", "!"), "Hello World"

call test "getSuffix$()"
call assert #lib getSuffix$("Hello world!", "apple"), ""
call assert #lib getSuffix$("Hello World!", "H"), "ello World!"
call assert #lib getSuffix$("Hello world!", "llo"), " world!"
call assert #lib getSuffix$("Hello World!", "!"), ""

call test "extract$()"
call assert #lib extract$("Hello World!", "hello", "orld"), ""
call assert #lib extract$("Hello World!", "W", "l"), "or"
call assert #lib extract$("Hello World!", "H", "!"), "ello World"

call test "replace$()"
call assert #lib replace$("Hello World!", "Hello", "Goodbye"), "Goodbye World!"
call assert #lib replace$("Hello World!", "!", "?"), "Hello World?"
call assert #lib replace$("Hello World!", "l", "z"), "Hezlo World!"

call test "replaceAll$()"
call assert #lib replaceAll$("Hello World!", "Hello", "Goodbye"), "Goodbye World!"
call assert #lib replaceAll$("Hello World!", "!", "?"), "Hello World?"
call assert #lib replaceAll$("Hello World!", "l", "z"), "Hezzo Worzd!"

call test "quote$()"
call assert #lib quote$(""), "''"
call assert #lib quote$("Hello World!"), "'Hello World!'"
call assert #lib quote$("Here's something ""Special"""), "'Here''s something ""Special""'"

call test "getUrlParam$()"
call assert #lib getUrlParam$("code=Hello%20World%21&num=234", "dummy"), ""
call assert #lib getUrlParam$("code=Hello%20World%21&num=234", "code"), "Hello World!"
call assert #lib getUrlParam$("code=Hello%20World%21&num=234", "num"), "234"

call test "urlEncode$()"
call assert #lib urlEncode$("abcdefghijklmnopqrstuvwxyz"), "abcdefghijklmnopqrstuvwxyz"
call assert #lib urlEncode$("ABCDEFGHIJKLMNOPQRSTUVWXYZ"), "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
call assert #lib urlEncode$("0123456789-_.~"), "0123456789-_.~"
call assert #lib urlEncode$("!#$&'()*+,/:;=?@[] "), "%21%23%24%26%27%28%29%2A%2B%2C%2F%3A%3B%3D%3F%40%5B%5D%20"

call test "urlDecode$()"
call assert #lib urlDecode$("abcdefghijklmnopqrstuvwxyz"), "abcdefghijklmnopqrstuvwxyz"
call assert #lib urlDecode$("ABCDEFGHIJKLMNOPQRSTUVWXYZ"), "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
call assert #lib urlDecode$("0123456789-_.~"), "0123456789-_.~"
call assert #lib urlDecode$("%21%23%24%26%27%28%29%2A%2B%2C%2F%3A%3B%3D%3F%40%5B%5D%20"), "!#$&'()*+,/:;=?@[] "

call summary

sub test what$
  testnum = 0
  print
  print "-----------------------------------------------"
  print "Starting testing of "; what$
  print "-----------------------------------------------"
end sub
 
sub assert in$, expected$
  testnum = testnum + 1
  print "Test "; testnum; " got <"; in$; ">, expected <"; expected$; "> - ";
  if in$ <> expected$ then
    testfailed = testfailed + 1
    print " FAILED"
  else
    testok = testok + 1
    print " Passed"
  end if
end sub

sub assertn in, expected
  call assert str$(in), str$(expected)
end sub

sub summary
  print
  print "==============================================="
  print testok + testfailed; " tests run"
  print testok; " test passed"
  print testfailed; " tests failed"
  print "==============================================="
end sub
