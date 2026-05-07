#!/bin/perl -n

use Text::Wrap;
use Lingua::EN::Titlecase;

# Remove single trailing spaces.
s/([^ ]) $/$1/gm;

# Use a meta-data tag for the title.
$. = 1 && s/^# (.*)/---\ntitle: "$1"\n---/;

# Change pseudo-headings into level-4 headings with correct title case.
s/^\*\*(.*?)\.?\*\* /
  $a = qr'([a-z]|[ivxc]{2,5})';
  $_ = $1;
  s,\($a\),(_Dummy_$1),g;
  $_ = "#### ".Lingua::EN::Titlecase->new($_)."\n\n";
  s,\(_Dummy_$a\),($1),g;
$_/e or
s/^\*\*(.*?)\*\*$/### $1/;

# Remove spaces surrounded em-dashes.
s/ (—) /$1/g;

# Start each sentence on a new line.
1 while s/^([A-Z].*?\w[\w)][:.]"?) (?=[A-Z])/$1\n/gm;

# Align the start of the text of numbered lists.
s/(?<=^\d\. )(?=[^ ])/ /;

# Wrap long lines.
$Text::Wrap::columns = 80;
/^(( *)(|\d\.  |\d\d. |- ))\*?[A-Z]/m and
$_ = wrap(' 'x length($2), ' 'x length($1), $_);

# Ensure there is a blank line after every heading.
s/^(#+ .*)\n(?=\w)/$1 /;

# Remove dividers before headings.
BEGIN { @l = ('') x 3; }
push @l, $_;
$_ = shift @l;
/^$/ && $l[0] =~ /^---$/ && $l[1] =~ /^$/ && $l[2] =~ /^#/ and $l[0] = '';
/^$/ && $l[0] =~ /^$/ and $_ = '';
print;
END { print @l; }

