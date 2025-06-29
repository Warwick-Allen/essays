#!/usr/bin/perl

use warnings;
use strict;
use Try::Tiny;

my $in = shift;
(my $base) = $in =~ /(.*)(?=\.)/;
my $out = "$base.html";
my $tmp = "$base.tex2html";

my $style = <<HERE;
 <style type="text/css">
 .block {
  margin-left: auto;
  margin-right: auto;
  width: 40em;
  text-align: justify;
  line-height: 3.5ex;
 }
 .abstract {
  width: 36em;
  margin-left: auto;
  margin-right: auto;
 }
 h2 {
   margin: 3ex auto 1.5ex auto;
 }
 h3 {
   margin: 2ex auto 1ex auto;
 }
</style>
HERE
try {
  system "cp '$in' '$tmp.tex'" and die $!;
  system "make4ht -x '$tmp.tex'" and die $!;

  my $ref_num;
  open IN, "$tmp.html" or die $!;
  open OUT, '>', $out or die $!;
  select OUT;
  sub strip {
    local $_ = $1;
    s/$_[0]//g;
    $_;
  }
  $/ = ">";
  while (<IN>) {
    s~ (?=</head>)                      ~$style\n~x                         or
    s~ (?<=<body>)                      ~\n<div class="block">~x            or
    s~ (?=</body>)                      ~</div><!-- class="block" -->\n~x   or
    1;
    print;
  }
  close OUT;
  close IN;
}
catch {
  print STDERR;
}
finally {
  system "rm $tmp*";
}
