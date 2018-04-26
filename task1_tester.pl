#!/usr/bin/perl -w

use File::Temp qw/tempfile/;

# -Inputs to write, as a reference to an array
# Returns:
# -A filehandle
# -A filename
sub writeToTempFile($) {
    my $inputRef = shift();

    my ($fh, $filename) = tempfile(UNLINK => 1);
    
    foreach my $input (@$inputRef) {
        print $fh "$input\n";
    }

    return ($fh, $filename);
}

# -The ASM file to test
# -The inputs to test with, as a reference to an array
# -Timeout length in seconds.  Values <= 0 mean no
#  timeout.
# Returns a reference to an array of outputs, one
# per line OR undef if the timeout expired
sub getOutput($$$) {
    my ($asmFile, $inputRef, $timeoutLen) = @_;
    my $command = "";
    
    if ($timeoutLen > 0) {
        $command = "timeout $timeoutLen ";
    }

    my ($fh, $filename) = writeToTempFile($inputRef);
    $command .= "spim -file '$asmFile' < '$filename'";
    my @retval = `$command`;
    for (my $x = 0; $x < scalar(@retval); $x++) {
	chomp($retval[$x]);
    }
    my $exitValue = $? >> 8;
    if ($timeoutLen > 0 && $exitValue == 124) {
        return undef;
    } else {
        return \@retval;
    }
}

# -ASM filename
# -Reference to array of inputs
# -Reference to array of expected outputs
# Returns 1 if it passed, else undef
sub runTest($$$) {
    my ($asmFile,
        $inputsRef,
        $expectedOutputRef) = @_;
    my $inputLen = scalar(@$expectedOutputRef);
    my $receivedOutputRef = getOutput($asmFile, $inputsRef, 3);

    if (defined($receivedOutputRef) &&
        scalar(@$receivedOutputRef) == $inputLen) {
        for (my $x = 0; $x < $inputLen; $x++) {
            if ($expectedOutputRef->[$x] ne $receivedOutputRef->[$x]) {
                return undef;
            }
        }
    } else {
	return undef;
    }

    return 1;
}

sub mkOutput($) {
    my $output = shift();
    my $enter = "Enter the next number:";
    my @retval = ("Loaded: /usr/share/spim/exceptions.s",
		  $enter,
                  $enter,
                  $enter,
                  "Median: $output");
    return \@retval;
}

# ---BEGIN MAIN CODE---


my @inputs = (["-1", "0", "1"],
              ["-1", "1", "0"],
              ["0", "-1", "1"],
              ["0", "1", "-1"],
              ["1", "-1", "0"],
              ["1", "0", "-1"],

              ["-1", "-2", "1"],
              ["-1", "1", "-2"],
              ["-2", "-1", "1"],
              ["-2", "1", "-1"],
              ["1", "-1", "-2"],
              ["1", "-2", "-1"],
              
              ["-1", "2", "1"],
              ["-1", "1", "2"],
              ["2", "-1", "1"],
              ["2", "1", "-1"],
              ["1", "-1", "2"],
              ["1", "2", "-1"]);

my @outputs = (mkOutput("0"),
               mkOutput("0"),
               mkOutput("0"),
               mkOutput("0"),
               mkOutput("0"),
               mkOutput("0"),

               mkOutput("-1"),
               mkOutput("-1"),
               mkOutput("-1"),
               mkOutput("-1"),
               mkOutput("-1"),
               mkOutput("-1"),

               mkOutput("1"),
               mkOutput("1"),
               mkOutput("1"),
               mkOutput("1"),
               mkOutput("1"),
               mkOutput("1"));

my $len = scalar(@inputs);
my $numPassed = 0;
my $numFailed = 0;
for (my $x = 0; $x < $len; $x++) {
    if (defined(runTest("MedianNumbers.asm",
                        $inputs[$x],
                        $outputs[$x]))) {
        $numPassed++;
    } else {
        print "Failed: " . join(", ", @{$inputs[$x]}) . "\n";
        $numFailed++;
    }
}

print "Num passed: $numPassed\n";
print "Num failed: $numFailed\n";
