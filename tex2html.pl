#!/usr/bin/perl

use warnings;
use strict;
use Try::Tiny;

sub getBib {
  local $_;
  my ($fh, %items, $key, $order, @html);
  open $fh, shift or die $!;
  while (<$fh>) {
    /\@(.\w+)\{(\w+),/ and do {
      $key = $2;
      $items{$key} = {type => $1, order => ++$order};
      next };
    /(\w+)\s*=\s*\{(.*)\}/ and do {
      my ($field, $value) = ($1, $2);
      $value =~ /^\{(.*)\}$/ and $value = $1;
      $items{$key}{$field} = $value;
    }
  }
  close $fh;

  my @fields = qw/
    author
    title
    booktitle
    journal
    series
    pages
    editor
    translator
    volume
    number
    publisher
    address
    year
    note
  /;
  return join '', map "$_\n",
    '  <div id="bibliography">',
    '    <h2>Bibliography</h2>',
    grep {length} map({
      my $item = $items{$_} or next;
      qq{    <div id="$_">},
      join('', grep {defined} map {
        $item->{$_} and do {
          my $field = $_;
          $field =~ s/(\w)/\U$1/;
          $field =~ s/kt/k T/;
          my $value = $item->{$_};
          $value =~ s/--/&ndash;/g;
          <<HERE}
      <div class="bib_$_">
        <div class="field">$field</div>
        <div class="value">$value</div>
      </div>
HERE
      } @fields).
      qq{    </div><!-- end $_ -->},
    } sort {$items{$a}{order} <=> $items{$b}{order}} keys %items),
    '  </div><!-- end bibliograhpy -->'
}

my $bib = getBib('references.bib');

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

 #bibliography > div:first-of-type {
   border-top: 1px solid grey;
 }
 #bibliography > div {
   border-bottom: 1px solid grey;
   padding: 1ex 0;
 }
 #bibliography > div > div > div {
   display:inline-block;
   line-height: 2.5ex;
 }
 #bibliography .field {
   color:grey;
   font-size: 75%;
   %font-variant-caps: small-caps;
   min-width: 8em;
   text-align: right;
 }
</style>
HERE
try {
  system "cp '$in' '$tmp.tex'" and die $!;
  system "make4ht -e $base.mk4 -x '$tmp.tex'" and die $!;

  my $ref_num;
  open IN, "$tmp.html" or die $!;
  open OUT, '>', $out or die $!;
  select OUT;
  sub getRef {
    our %div;
    my $fname = shift;
    open FH, $fname or die "Cannot open '$fname': $!";
    undef local $/;
    local $_ = <FH>;
    close FH;
    m~(<div\b.*?/div>)~s or die "Cannot find div in '$fname'";
    $_ = $1;
    /class='ec-lmbx-10'>(.*?)</ && $1
  }
  $/ = ">";
  while (<IN>) {
    s~ (?=</head>) ~$style\n~x                                      or
    s~ (?<=<body>) ~\n<div class="block">~x                         or
    s~ ($tmp\d+\.html)\#\w+ ~my $r = getRef $1; "#$r' title='$r"~xe or
    s~ (?=</body>) ~$bib</div><!-- class="block" -->\n~x          or
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
