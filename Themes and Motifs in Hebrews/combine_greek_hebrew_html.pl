#!/usr/bin/perl -w

# Script to combine Greek and Hebrew versions of an HTML document
# Creates a single HTML file with toggleable sections for Greek/Hebrew names
# Usage: ./combine_greek_hebrew_html.pl <base_name>
# Example: ./combine_greek_hebrew_html.pl themes_and_motifs_in_hebrews
#
# VALIDATION:
# - Validates that base filename is provided and contains valid characters
# - Validates that all required input files exist and are readable:
#   * <base_name>.greek.html (main input file)
#   * <base_name>.greek.block.html (Greek block content)
#   * <base_name>.hebrew.block.html (Hebrew block content)
#   * bibliography-lookup-table.yaml (bibliography lookup table YAML source)
#   * bibliography-lookup-table-yaml-to-html.pl (conversion script)
# - Validates that input file contains required HTML markers
# - Validates that output directory is writable
# - Exits with error messages if validation fails

use strict;
use warnings;
use File::Spec;

# ============================================================================
# VALIDATION FUNCTIONS
# ============================================================================

# Validate that a file exists and is readable
# Returns 1 if valid, 0 otherwise
sub validate_file {
  my ($file, $description) = @_;

  unless (defined $file && length $file > 0) {
    print STDERR "Error: $description filename is not specified\n";
    return 0;
  }

  unless (-e $file) {
    print STDERR "Error: $description file does not exist: $file\n";
    return 0;
  }

  unless (-r $file) {
    print STDERR "Error: $description file is not readable: $file\n";
    return 0;
  }

  unless (-f $file) {
    print STDERR "Error: $description is not a regular file: $file\n";
    return 0;
  }

  # Check if file is empty
  if (-z $file) {
    print STDERR "Error: $description file is empty: $file\n";
    return 0;
  }

  return 1;
}

# Validate that a directory is writable (for output file)
# Returns 1 if valid, 0 otherwise
sub validate_directory_writable {
  my ($file) = @_;
  my ($volume, $directories, $filename) = File::Spec->splitpath($file);

  # If no directory specified, use current directory
  my $dir = $directories;
  $dir = '.' unless defined $dir && length $dir > 0;

  # Remove trailing separator if present
  $dir =~ s/[\/\\]$// if length $dir > 1;

  unless (-d $dir) {
    print STDERR "Error: Output directory does not exist: $dir\n";
    return 0;
  }

  unless (-w $dir) {
    print STDERR "Error: Output directory is not writable: $dir\n";
    return 0;
  }

  return 1;
}

# Validate that input file contains required markers
# Returns 1 if valid, 0 otherwise
sub validate_input_content {
  my ($file) = @_;

  open my $fh, '<', $file or do {
    print STDERR "Error: Cannot open file for content validation: $file\n";
    return 0;
  };

  my $found_opening = 0;
  my $found_closing = 0;
  my $line_num = 0;

  while (my $line = <$fh>) {
    $line_num++;
    if ($line =~ /<div class="block">/) {
      $found_opening = 1;
    }
    if ($line =~ /<!--\s+class="block"\s+-->/) {
      $found_closing = 1;
      last;
    }
  }

  close $fh;

  unless ($found_opening) {
    local ($\, $,) = ("\n", "  ");
    print STDERR 'Error: Input file does not contain required opening tag:',
      '<div class="block">';
    print STDERR '  File:', $file;
    return 0;
  }

  unless ($found_closing) {
    local ($\, $,) = ("\n", "  ");
    print STDERR 'Error: Input file does not contain required closing comment:',
      '<!-- class="block" -->';
    print STDERR '  File:', $file;
    return 0;
  }

  return 1;
}

# Validate base filename
# Returns 1 if valid, 0 otherwise
sub validate_base_filename {
  my ($filename) = @_;

  unless (defined $filename && length $filename > 0) {
    print STDERR "Error: Base filename is required\n";
    print STDERR "Usage: $0 <base_name>\n";
    print STDERR "Example: $0 themes_and_motifs_in_hebrews\n";
    return 0;
  }

  # Check for invalid characters in filename
  if ($filename =~ /[<>:"|?*\x00-\x1f]/) {
    print STDERR "Error: Base filename contains invalid characters: ",
      "$filename\n";
    return 0;
  }

  # Check for path separators (should be just a base name, not a path)
  if ($filename =~ /[\/\\]/) {
    print STDERR "Error: Base filename should not contain path separators: ",
      "$filename\n";
    return 0;
  }

  return 1;
}

# ============================================================================
# INPUT VALIDATION
# ============================================================================

# Get the base filename from command line argument
our $t = shift @ARGV;

# Validate base filename
unless (validate_base_filename($t)) {
  exit 1;
}

# Define required files
my $greek_html = "$t.greek.html";
my $greek_block = "$t.greek.block.html";
my $hebrew_block = "$t.hebrew.block.html";
my $lookup_table_yaml = 'bibliography-lookup-table.yaml';
my $lookup_table_script = 'bibliography-lookup-table-yaml-to-html.pl';
my $output_file = "$t.html";

# Validate all required input files
my $validation_failed = 0;

unless (validate_file($greek_html, "Greek HTML input")) {
  $validation_failed = 1;
}

unless (validate_file($greek_block, "Greek block")) {
  $validation_failed = 1;
}

unless (validate_file($hebrew_block, "Hebrew block")) {
  $validation_failed = 1;
}

unless (validate_file($lookup_table_yaml, "Bibliography lookup table YAML")) {
  $validation_failed = 1;
}

unless (validate_file($lookup_table_script, "Bibliography lookup table conversion script")) {
  $validation_failed = 1;
}

# Validate output directory is writable
unless (validate_directory_writable($output_file)) {
  $validation_failed = 1;
}

# Validate input file content contains required markers
unless (validate_input_content($greek_html)) {
  $validation_failed = 1;
}

# Exit if validation failed
if ($validation_failed) {
  print STDERR "\nValidation failed. Please check the errors above and try again.\n";
  exit 1;
}


# Subroutine to print a language-specific block section
# Parameters:
#   $lang - Language code ('greek' or 'hebrew')
#   $disp - CSS display value ('block' or 'none')
#   $link - Mega.nz file link for the PDF version
sub printBlock {
  our $t;  # Access the global base filename
  my ($lang, $disp, $link) = @_;

  # Set output record separator to newline for this subroutine
  local $\ = "\n";

  # Build the filename for the language-specific block file
  # Example: themes_and_motifs_in_hebrews.greek.block.html
  local $_ = "$t.$lang.block.html";

  # Print the opening section tag with display style and PDF link
  print <<HERE;
  <section id="name_$lang" style="display:$disp">
    <a href="https://mega.nz/file/$link" target="_blank">
      <strong>Click here to see the PDF version</strong>
    </a>
HERE

  # Open and read the entire block file for this language
  # Note: File existence has already been validated, but check again for safety
  unless (-e $_ && -r $_) {
    die "Error: Block file does not exist or is not readable: $_\n";
  }
  open BLK, $_ or die "Cannot open $_: $!";

  # Process each line to append language suffix to all IDs and internal links
  while (<BLK>) {
    # Append language suffix to ALL id attributes
    # Match: id="X" or id='X' where X is any identifier
    # Replace with: id="X-lang" or id='X-lang'
    # This ensures no duplicate IDs exist between Greek and Hebrew sections
    s/(id=["'])([^"']+)(["'])/$1$2-$lang$3/g;

    # Append language suffix to ALL internal links (href attributes pointing to anchors)
    # Match: href='#X' or href="#X" where X is any identifier
    # Replace with: href='#X-lang' or href="#X-lang"
    # This ensures links point to the correct language-specific IDs
    s/(href=["']#)([^"']+)(["'])/$1$2-$lang$3/g;

    print;  # Print the processed line
  }
  close BLK;

  # Print the closing section tag
  print qq{  </section><!-- end name_$lang -->\n};
}

# ============================================================================
# MAIN SCRIPT EXECUTION
# ============================================================================

# Set up output file (will be overwritten if it exists)
$_ = "$t.html";
open OUT, ">$_" or die "Cannot open $_: $!";

# Set up input file (the Greek version, which has the complete HTML structure)
$_ = "$t.greek.html";

# Make OUT the default output filehandle (all 'print' statements go here)
select OUT;

# Open the input file for reading
open IN, $_ or die "Cannot open $_: $!";

# Read and print the HTML header from the input file
# This includes: <!DOCTYPE>, <html>, <head>, <style>, etc.
# Stop when we encounter the opening <div class="block"> tag
while (<IN>) {
  # Update CSS selectors for bibliography to target both language versions
  # Replace #bibliography with #bibliography-greek, #bibliography-hebrew
  s/#bibliography(?!-greek|-hebrew)/#bibliography-greek, #bibliography-hebrew/g;
  print;  # Print each line as we read it
  /<div class="block">/ and last;  # Stop reading when we hit the content div
}

# Insert the toggle button for switching between Greek and Hebrew versions
print <<HERE;
  <button id="btn_chgName">Use Greek-based names</button>
HERE

# Insert the Greek version block (initially hidden)
# The PDF link is for the Greek version
printBlock 'greek' , 'none' , '9qAVwAKL#GGiosqyC0WU0C4rLFtHtQlHk1rLuPEq2UmSiB7JUY_w';

# Insert the Hebrew version block (initially visible)
# The PDF link is for the Hebrew version
printBlock 'hebrew', 'block', 'F7oRlYKa#3WjuxyjfhlQMrRqPhAH_oGcvfLLFXAXgKhmp7tRvgeg';

# Insert JavaScript to handle the toggle button functionality
# When clicked, it switches the display style of the Greek and Hebrew sections
print <<HERE;
  <script>
    const button = document.getElementById('btn_chgName');
    const greek  = document.getElementById('name_greek' );
    const hebrew = document.getElementById('name_hebrew');

    button.addEventListener('click', () => {
      if (button.textContent.substr(4, 1) === 'H') {
        greek.style.display  = 'none' ;
        hebrew.style.display = 'block';
        button.textContent = 'Use Greek-based names' ;
      }
      else {
        greek.style.display  = 'block';
        hebrew.style.display = 'none' ;
        button.textContent = 'Use Hebrew-based names';
      }
    });
  </script>
HERE

# ============================================================================
# BIBLIOGRAPHY LOOKUP TABLE
# ============================================================================

# Generate the bibliography lookup table HTML from YAML source
# The YAML file and conversion script have already been validated
# This table provides links and access information for bibliography sources
system qq{perl bibliography-lookup-table-yaml-to-html.pl} and
  die "Error: Failed to generate bibliography lookup table HTML: $!";
{
  my $lookup_file = 'bibliography-lookup-table.html';

  unless (-e $lookup_file && -r $lookup_file) {
    die "Error: Bibliography lookup table does not exist or is not readable: $lookup_file\n";
  }

  open my $lookup_fh, '<', $lookup_file or die "Cannot open: $lookup_file: $!";

  # Temporarily set input record separator to undef to read entire file at once
  # This is necessary because the lookup table might not end with a newline
  local $/ = undef;  # Read entire file as a single string

  my $lookup_content = <$lookup_fh>;
  close $lookup_fh;

  # Validate that we actually read some content
  unless (defined $lookup_content && length $lookup_content > 0) {
    die "Error: Bibliography lookup table file is empty: $lookup_file\n";
  }

  # Note: $/ automatically reverts to "\n" after this block ends due to 'local'
  # This is important because we need line-by-line reading for the input file handle

  # Convert plain text URLs in the lookup table to clickable links
  # Pattern: >https://(url)</ becomes ><a href="https://url">url</a></
  $lookup_content =~ s~>https://(.*?)</~><a href="https://$1">$1</a></~sg;

  # Print the processed lookup table content
  print $lookup_content;
}

# ============================================================================
# SKIP DUPLICATE CONTENT FROM INPUT FILE
# ============================================================================

# At this point, the file handle IN is still open and positioned right after
# the opening <div class="block"> tag. The input file contains the full
# document content (including bibliography) which we've already inserted
# via the printBlock() calls above. We need to skip all of this duplicate
# content until we reach the closing comment.

# Skip ALL content from the input file until we find the closing comment
# We must NOT print any of these lines - they would duplicate content already
# inserted via the language blocks
my $max_lines_to_skip = 10000;  # Safety limit to prevent infinite loops
my $lines_skipped = 0;
my $found_closing_comment = 0;

while (defined(my $line = <IN>)) {
  $lines_skipped++;

  # Safety check: if we've skipped too many lines, something is wrong
  if ($lines_skipped > $max_lines_to_skip) {
    warn "Warning: Skipped more than $max_lines_to_skip lines without finding closing comment\n";
    warn "  This may indicate the input file is malformed or missing the closing comment\n";
    last;
  }

  # Check if this line contains the closing comment marker
  # The pattern matches: <!-- class="block" --> (with optional whitespace)
  if ($line =~ /<!--\s+class="block"\s+-->/) {
    # Found the closing comment - print it and stop reading
    # This comment appears at the end of the content div in the input file
    print $line;
    $found_closing_comment = 1;
    last;  # Exit the loop
  }
  # CRITICAL: Do NOT print this line - we're skipping all content
  # This includes the bibliography, which is already in the language blocks
}

# Warn if we didn't find the closing comment
unless ($found_closing_comment) {
  warn "Warning: Did not find closing comment <!-- class=\"block\" --> in input file\n";
  warn "  The output file may be incomplete\n";
}

# ============================================================================
# CLOSING TAGS
# ============================================================================

# Print the remaining closing tags from the input file
# These should be: </div><!-- class="block" --> (already printed above),
#                  </body>, and </html>
while (defined(my $line = <IN>)) {
  print $line;
}

# Close the input file handle
close IN;

# The output file handle OUT will be automatically closed when the script exits
