#!/usr/bin/env perl
use strict;
use warnings;

# Read input file from command line argument or use default
my $input_file = $ARGV[0] || 'bibliography-lookup-table.yaml';
my $output_file = $ARGV[1] || 'bibliography-lookup-table.html';

# Open input file
open(my $in_fh, '<:utf8', $input_file) or die "Cannot open $input_file: $!\n";

# Read all lines
my @lines = <$in_fh>;
close($in_fh);

# Function to escape only dangerous HTML characters
sub escape_html {
    my $text = shift;
    $text =~ s/&/&amp;/g;
    $text =~ s/</&lt;/g;
    $text =~ s/>/&gt;/g;
    $text =~ s/"/&quot;/g;
    return $text;
}

# Parse YAML entries
my @entries;
my $current_entry = [];

foreach my $line (@lines) {
    chomp $line;
    
    # Check if this is a new entry (starts with "- -")
    if ($line =~ /^- - (.+)$/) {
        # Save previous entry if it exists (with at least 3 fields: source, access, url)
        if (@$current_entry >= 3) {
            # Pad with empty notes if missing
            push @$current_entry, '' if @$current_entry == 3;
            push @entries, $current_entry;
        }
        # Start new entry
        $current_entry = [$1];  # Source name
    }
    # Check if this is a field (starts with "  - ")
    elsif ($line =~ /^  - (.+)$/) {
        push @$current_entry, $1;
    }
}

# Don't forget the last entry
if (@$current_entry >= 3) {
    # Pad with empty notes if missing
    push @$current_entry, '' if @$current_entry == 3;
    push @entries, $current_entry;
}

# Generate HTML
open(my $out_fh, '>:utf8', $output_file) or die "Cannot open $output_file for writing: $!\n";

print $out_fh "<h3>Bibliography Look-Up Table</h3>\n";
print $out_fh "<table border=\"1\" class=\"dataframe\">\n";
print $out_fh "  <thead>\n";
print $out_fh "    <tr>\n";
print $out_fh "      <th>Source</th>\n";
print $out_fh "      <th>Access Type</th>\n";
print $out_fh "      <th>Platform/Link</th>\n";
print $out_fh "      <th>Notes</th>\n";
print $out_fh "    </tr>\n";
print $out_fh "  </thead>\n";
print $out_fh "  <tbody style=\"text-align:left; font-size:80%\">\n";

foreach my $entry (@entries) {
    my ($source, $access_type, $url, $notes) = @$entry;
    
    # Escape only dangerous HTML characters
    $source = escape_html($source);
    $access_type = escape_html($access_type);
    $url = escape_html($url);
    $notes = escape_html($notes);
    
    print $out_fh "    <tr>\n";
    print $out_fh "      <td>$source</td>\n";
    print $out_fh "      <td>$access_type</td>\n";
    print $out_fh "      <td>$url</td>\n";
    print $out_fh "      <td>$notes</td>\n";
    print $out_fh "    </tr>\n";
}

print $out_fh "  </tbody>\n";
print $out_fh "</table>\n";

close($out_fh);

print "Successfully converted $input_file to $output_file\n";
print "Processed " . scalar(@entries) . " entries\n";

