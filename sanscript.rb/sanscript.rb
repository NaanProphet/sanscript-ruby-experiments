require "execjs"
require "open-uri"

# arguments:
# 1) input file
# 2) output file (will overwrite)
# 3) input language (e.g. itrans)
# 4) output language (e.g. iast, telugu)

def internet_connection?
  begin
    true if open("http://www.google.com/")
  rescue
    false
  end
end

if internet_connection?
     rawSource = open("https://raw.githubusercontent.com/sanskrit/sanscript.js/3e109b09d0e69de1afb166ebd4d1ffb4e340a0c3/sanscript/sanscript.js").read
else
     rawSource = File.open(File.dirname(__FILE__) + "../sanscript.js/sanscript/sanscript.js").read
end

# Sanscript expects the browser object model (BOM), so emulate it for ExecJS
bomSnippet = 'var Sanscript = {}; var window = { Sanscript }; ';
source = bomSnippet + rawSource;

context = ExecJS.compile(source)

file = File.open(ARGV[0], "r:UTF-8")
contents = file.read

result = context.call 'Sanscript.t', contents, ARGV[2], ARGV[3]

File.write(ARGV[1], result)


# special thanks to:
# http://stackoverflow.com/questions/5163339/write-and-read-a-file-with-utf-8-encoding
# http://stackoverflow.com/questions/2777802/how-to-write-to-file-in-ruby
# http://stackoverflow.com/questions/4244611/pass-variables-to-ruby-script-via-command-line
# http://stackoverflow.com/questions/2385186/check-if-internet-connection-exists-with-ruby
# http://stackoverflow.com/questions/130948/ruby-convert-file-to-string
# https://www.ruby-forum.com/topic/143383