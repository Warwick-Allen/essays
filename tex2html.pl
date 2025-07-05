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
 .maketitle {
  text-align: center;
 }
 .author {
  margin-top: 5ex;
  margin-bottom: -1ex;
  font-size: 3ex;
 }
 .date {
  margin-bottom: 4ex;
  font-size: 3ex;
 }
 .abstract {
  width: 36em;
  margin-left: auto;
  margin-right: auto;
 }
 .abstracttitle {
  margin-top: 4ex;
  font-size: 2.5ex;
  text-align: center;
 }
 h2 {
   margin-top: 3ex;
   margin-bottom: 1.5ex;
 }
 h2.titleHead {
  font-size: 4ex;
  line-height: 4ex;
 }
 h3 {
   margin-top: 2ex;
   margin-bottom: 1ex;
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
