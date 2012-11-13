@rem = '--*-Perl-*--
@echo off
if "%OS%" == "Windows_NT" goto WinNT
perl -x -S "%0" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto endofperl
:WinNT
perl -x -S %0 %*
if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" goto endofperl
if %errorlevel% == 9009 echo You do not have Perl in your PATH.
if errorlevel 1 goto script_failed_so_exit_with_non_zero_val 2>nul
goto endofperl
@rem ';
#!/usr/bin/perl
#line 15
# tctee - clone that groks process tees 
# perl3 compatible, or better.

while ($ARGV[0] =~ /^-(.+)/ && (shift, ($_ = $1), 1)) {
    next if /^$/;
    s/i// && (++$ignore_ints, redo);
    s/a// && (++$append,      redo);
    s/u// && (++$unbuffer,    redo);
    s/n// && (++$nostdout,    redo);
    die "usage tee [-aiun] [filenames] ...\n";
}

if ($ignore_ints) {
    for $sig ('INT', 'TERM', 'HUP', 'QUIT') { $SIG{$sig} = 'IGNORE'; }
}

$SIG{'PIPE'} = 'PLUMBER';
$mode = $append ? '>>' : '>';
$fh = 'FH000';

unless ($nostdout) {
    %fh = ('STDOUT', 'standard output'); # always go to stdout
    }

$| = 1 if $unbuffer;

for (@ARGV) {
    if (!open($fh, (/^[^>|]/ && $mode) . $_)) {
        warn "$0: cannot open $_: $!\n"; # like sun's; i prefer die
        $status++;
        next;
    }
    select((select($fh), $| = 1)[0]) if $unbuffer;
    $fh{$fh++} = $_;
}

while (<STDIN>) {
    for $fh (keys %fh) {
        print $fh $_;
    }
}

for $fh (keys %fh) {
    next if close($fh) || !defined $fh{$fh};
    warn "$0: couldnt close $fh{$fh}: $!\n";
    $status++;
}

exit $status;

sub PLUMBER {
    warn "$0: pipe to \"$fh{$fh}\" broke!\n";
    $status++;
    delete $fh{$fh};
}

__END__
:endofperl
