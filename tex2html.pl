#!/usr/bin/perl

use warnings;
use strict;
use Try::Tiny;

my $in = shift;
my $out = do {local $_ = $in; s/(?:\.[^\.]*|)$/.html/; $_};
my $tmp = do {local $_ = `mktemp -u`; chomp; $_};

my $style = <<HERE;
 <style type="text/css">
 .block {
  margin-left: auto;
  margin-right: auto;
  width: 40em;
  text-align: justify;
 }
 .abstract {
  width: 36em;
 }
 .abstract h2 {
  font-size: 110%;
  text-align: center;
 }
 h2 {
   margin: 3ex auto 1.5ex auto;
 }
 h3 {
   margin: 2ex auto 1ex auto;
 }
 dl {
   display: grid;
   grid-template-columns: max-content auto;
 }
 dt {
   grid-column-start: 1;
 }
 dd {
   grid-column-start: 2;
   margin-left: 0;
   text-indent: 0.5em;
 }
</style>
HERE
try {
  $/ = "\n\n";

  open IN, $in or die $!;
  open OUT, '>', "$tmp.tex" or die $!;
  select OUT;
  while (<IN>) {
    s~         ’          ~! apos  !~xg ;
    s~      \\(l|r)q({})? ~!$1squo !~xg ;
    s~         ``         ~! ldquo !~xg ;
    s~         ''         ~! rdquo !~xg ;
    s~ (?<=\w) --- (?=\w) ~! mdash !~xg ;
    s~ (?<=\w) --  (?=\w) ~! ndash !~xg ;
    print;
  }
  close OUT;
  close IN;

  system "tth '$tmp.tex'";

  my $ref_num;
  open IN, "$tmp.html" or die $!;
  open OUT, '>', $out or die $!;
  select OUT;
  sub strip {
    local $_ = $1;
    s/$_[0]//g;
    $_;
  }
  while (<IN>) {
    s~ !\s* (\w+) \s*!                  ~&$1;~xg                            ;
    s~ <a\b.*?/a>                       ~~xg                                ;
    s~ (?<=<title>)([^<]*)              ~strip qr/(^|\\) */ ~xe             ;
    s~ (<h1\b.*?</h1>)                  ~strip qr,(<br />| (?=</)), ~xe     ;
    s~ (<meta\s.*)                      ~<head>$1$style\n~xs                or
    s~ (?<=</title>)                    ~\n</head><body class="block">\n~xs or
    s~ \s*(?=<h2>.*Abstract.*</h2>)     ~<div class="block abstract">\n~xs  or
    s~ \s*(?=<h2>.*Introduction.*</h2>) ~</div>\n~xs                        or
    s~ (?<=<dt>\[)(?=\]</dt>)           ~++$ref_num~xe                      ;
    s~ .*File.translated.from.*         ~</body>\n</html>~xs                ;
    print;
  }
  close OUT;
  close IN;
}
catch {
  print STDERR;
}
finally {
  system "[ -e '$tmp.$_' ] && rm '$tmp.$_'" for qw/tex html/;
}
