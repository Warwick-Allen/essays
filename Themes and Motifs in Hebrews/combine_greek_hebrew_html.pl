#!/usr/bin/perl -w

our $t = shift @ARGV;

sub printBlock {
  our $t;
  my ($lang, $disp, $link) = @_;
  local $\ = "\n";
  local $_ = "$t.$lang.block.html";
  print <<HERE;
  <section id="name_$lang" style="display:$disp">
    <a href="https://mega.nz/file/$link" target="_blank">
      <strong>Click here to see the PDF version</strong>
    </a>
HERE
  open BLK, $_ or die "Cannont open $_: $!";
  while (<BLK>) {print}
  close BLK;
  print qq{  </section><!-- end name_$lang -->\n};
}

$_ = "$t.html";
open OUT, ">$_" or die "Cannot open $_: $!";
$_ = "$t.greek.html";
select OUT;
open IN, $_ or die "Cannot open $_: $!";
while (<IN>) {
  print;
  /<div class="block">/ and last;
}
print <<HERE;
  <button id="btn_chgName">Use Greek-based names</button>
HERE
printBlock 'greek' , 'none' , 'FmpjjDJC#uuCST1pwXcXzk9FmAMW0Xo9fBWvEG4ltidF3zQCtzVs';
printBlock 'hebrew', 'block', 'Z64jzKaa#N_2U8p1RsFLAM1lU_HZ5ZQTKe4h0-9gxY9EHO0e1o7k';
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
# Read and print the bibliography lookup table
# IMPORTANT: Use a separate block to isolate the $/ change
{
  my $lookup_file = 'bibliography-lookup-table.html';
  open my $lookup_fh, '<', $lookup_file or die "Cannot open: $lookup_file: $!";
  local $/ = undef;  # Read entire file at once
  my $lookup_content = <$lookup_fh>;
  close $lookup_fh;
  # $/ automatically reverts to "\n" after this block due to 'local'
  $lookup_content =~ s~>https://(.*?)</~><a href="https://$1">$1</a></~sg;
  print $lookup_content;
}

# Now skip ALL content from the input file until we find the closing comment
# The file handle IN is still open and positioned right after <div class="block">
# We must NOT print anything until we find <!-- class="block" -->
# Read lines but DO NOT print them until we find the closing comment
my $line_count = 0;
while (defined(my $line = <IN>)) {
  $line_count++;
  if ($line =~ /<!--\s+class="block"\s+-->/) {
    # Found the closing comment - print it and break
    print $line;
    last;
  }
  # CRITICAL: Do NOT print this line - we're skipping all content (bibliography, etc.)
}
# Print the remaining closing tags (</body></html>)
while (defined(my $line = <IN>)) {
  print $line;
}
close IN;
