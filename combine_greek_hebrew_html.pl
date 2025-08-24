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
$_ = <<HERE;
<h3>Bibliography Look-Up Table</h3>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th>Source</th>
      <th>Access Type</th>
      <th>Platform/Link</th>
      <th>Notes</th>
    </tr>
  </thead>
  <tbody style="text-align:left; font-size:80%">
    <tr>
      <td>Augustine – On the Spirit and the Letter (1887)</td>
      <td>✅ Free</td>
      <td>https://ccel.org/ccel/schaff/npnf105.html</td>
      <td>In Nicene and Post-Nicene Fathers, First Series, Vol. 5</td>
    </tr>
    <tr>
      <td>Bruce, F. F. – The Epistle to the Hebrews (1964)</td>
      <td>❌ Paywalled</td>
      <td>https://books.google.com</td>
      <td>NICNT series; available via libraries or Logos</td>
    </tr>
    <tr>
      <td>Calvin, John – Commentaries on Hebrews (1853)</td>
      <td>✅ Free</td>
      <td>https://archive.org/details/commentariesonep00calvuoft</td>
      <td>Calvin Translation Society edition</td>
    </tr>
    <tr>
      <td>Cyril of Jerusalem – Catechetical Lectures (1894)</td>
      <td>✅ Free</td>
      <td>https://www.newadvent.org/fathers/3101.htm</td>
      <td>In NPNF, Second Series, Vol. 7; also on CCEL</td>
    </tr>
    <tr>
      <td>Cockerill – The Epistle to the Hebrews (2012)</td>
      <td>❌ Paywalled</td>
      <td>https://www.worldcat.org/title/epistle-to-the-hebrews/oclc/774021037</td>
      <td>NICNT volume; available in libraries or Logos</td>
    </tr>
    <tr>
      <td>Edwards – Religious Affections (1959)</td>
      <td>✅ Free</td>
      <td>https://ccel.org/ccel/edwards/religiousaffections</td>
      <td>Yale edition not free, but original is public domain</td>
    </tr>
    <tr>
      <td>Edwards – The Excellency of Christ (2001)</td>
      <td>✅ Free (sermon)</td>
      <td>https://www.monergism.com/excellency-christ</td>
      <td>Full Yale edition not free; sermon is public domain</td>
    </tr>
    <tr>
      <td>Hughes – Commentary on Hebrews (1977)</td>
      <td>❌ Paywalled</td>
      <td>NaN</td>
      <td>Library or Logos only</td>
    </tr>
    <tr>
      <td>Lane – Hebrews 1–8 (WBC 47A, 1991)</td>
      <td>❌ Paywalled</td>
      <td>https://books.google.com</td>
      <td>WBC volume; available in print or digital</td>
    </tr>
    <tr>
      <td>Luther – Lectures on Hebrews (LW 29, 1968)</td>
      <td>❌ Paywalled</td>
      <td>https://www.projectwittenberg.org/</td>
      <td>Full Pelikan edition not free</td>
    </tr>
    <tr>
      <td>O’Brien – The Letter to the Hebrews (2010)</td>
      <td>❌ Paywalled</td>
      <td>https://www.worldcat.org/title/letter-to-the-hebrews/oclc/555667274</td>
      <td>Pillar commentary; available in Logos, Kindle, print</td>
    </tr>
    <tr>
      <td>Owen – Exposition of Hebrews (1854–55)</td>
      <td>✅ Free</td>
      <td>https://www.monergism.com/exposition-epistle-hebrews-7-volume-set</td>
      <td>Full 7-volume set, public domain</td>
    </tr>
    <tr>
      <td>Schreiner – Covenant and God’s Purpose (2017)</td>
      <td>❌ Paywalled</td>
      <td>https://books.google.com</td>
      <td>Part of Short Studies in Biblical Theology series</td>
    </tr>
    <tr>
      <td>Sproul – The Holiness of God (1985)</td>
      <td>❌ Paywalled</td>
      <td>https://www.ligonier.org/store/the-holiness-of-god-paperback/</td>
      <td>Available in multiple formats</td>
    </tr>
    <tr>
      <td>Wesley – Explanatory Notes on the NT (1755)</td>
      <td>✅ Free</td>
      <td>https://ccel.org/ccel/wesley/notes</td>
      <td>Also available via the Wesley Center</td>
    </tr>
    <tr>
      <td>Harris – Use of the OT in Hebrews (2021)</td>
      <td>✅ Free</td>
      <td>https://equipthecalled.com/wp-content/uploads/2024/07/SWJT-Vol.-64-No.-1.pdf</td>
      <td>SWJT article, free from EquipTheCalled</td>
    </tr>
    <tr>
      <td>Guthrie – Structure of Hebrews (PhD diss.)</td>
      <td>❌ Paywalled Book</td>
      <td>https://www.worldcat.org/title/structure-of-hebrews-a-text-linguistic-analysis/oclc/32346865</td>
      <td>Brill (1994), Baker (1998); check libraries or purchase</td>
    </tr>
    <tr>
      <td>Guthrie – 'Hebrews' in NT Use of OT (2007)</td>
      <td>❌ Paywalled</td>
      <td>https://www.logos.com/product/5489/commentary-on-the-nt-use-of-the-ot</td>
      <td>Chapter by Guthrie; in Beale & Carson; Logos or print only</td>
    </tr>
  </tbody>
</table>
HERE
s~>https://(.*?)</~><a href="https://$1">$1</a></~sg;
print;
while (<IN>) {/<!-- class="block" -->/ and print and last}
while (<IN>) {print}
