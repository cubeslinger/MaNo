#!/bin/perl -w
use strict;
use warnings;
package csvtolua;
use Getopt::Std;

BEGIN
  {
  use Exporter   ();
  our           ($VERSION, $PRG, $AUTHOR, @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);
  # set the version for version checking
  $VERSION    = '0.1';
  $PRG        = $0;
  $AUTHOR     = 'marcob@marcob.org';

  @ISA        = qw( Exporter );
  @EXPORT     = qw( $VERSION );

  %EXPORT_TAGS= ( );
  @EXPORT_OK  = qw( $VERSION );
  }

our @EXPORT_OK;
our $VERSION;
our $PRG;
our $AUTHOR;

sub _read_params
  {
  ##
  ##  Valid Switches:
  ##
  ##    -i <FILE>         input file to fix
  ##
  my  (%u)        = ();
  my  ($in)       = undef;
  #
  if  (getopts('i:', \%u))
    {
    if  ( $u{'i'} ) { $in = $u{'i'};  }
    else
      {
      if  (!$in)  { &_print_usage();  }
      }
    }
  ##
  return($in);
  }

 sub   _print_usage()
  {
  print "\n".$PRG.' v.'.$VERSION.' - '.$AUTHOR."\n\n";
  print 'Usage: '.$PRG.' [-i <video2fix> [-r || -o <fixedvideo>] || -l <file.lst>] [-h]'."\n\n";
  print '       -i <file2parse.csv>  filenane.csv to convert to lua table'."\n";
  print "\n";

  return(0);
  }

my ($i) = &_read_params();
my ($retval)  = 1;
my (@files)   = ();
my (@outhash) = ();
if  ($i)
  {
  if (-r $i)
    {
    if (open( IN, "<$i"))
      {
      @files = <IN>;
      close(IN);
      chomp(@files);

      my $outfile = $i . '.lua';

      my $line = undef;
      foreach $line (@files)
        {
        my($z, $t, $e)  = split(/\,/, $line);
        $z =~  s/^\s+//;
        $t =~  s/^\s+//;
        $e =~  s/^\s+//;
        push(@outhash, '{ zonename='.$z.', zonetype='.$t.', expansion='.$e.', zoneid="" },');
        }

      if(open( OUT, ">$outfile"))
        {
        foreach $line (@outhash)
          {
          print OUT "$line\n";
        }
        close(OUT);
        }
      }
    else
      {
      print "ERROR: can\'t read list file: $i, $?\n";
      }
    }
  }
exit();

