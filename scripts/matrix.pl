open(IN1, "$ARGV[0].vcf");
open(OUT, ">$ARGV[0].matrix.csv");

%h=(); # final hash for printing
@samples = ();
$cc=0;

#
# 0=CHROM 1=POS 2=ID 3=REF 4=ALT 5=QUAL 6=FILTER 7=INFO 8=FORMAT 9..254=samples
    
while(<IN1>){
    chomp($_);
    @r=split/\s+/,$_;
 #   print "\n$r[1]";
    if($_ =~ /##/){ ; }
    elsif($_ =~ /#/){
	@samples = @r; 
    }
    else { 
    for $e (9..$#r){
	for $ee (9..$#r){
	    $h{$e}{$ee} = $h{$e}{$ee} + abs($r[$e]-$r[$ee]);
	}  # end for
    } # end for
    }
}    # end while

print OUT "Samples";
for $e (sort {$a <=> $b} keys %h){
    $samples[$e]=~ s/EC_//g;
    print OUT "\t",$samples[$e];
}

for $e (sort {$a <=> $b} keys %h){
    $samples[$e]=~ s/EC_//g;
    print OUT "\n",$samples[$e];
    for $ee (sort {$a <=> $b} keys %{$h{$e}}){
	print OUT "\t",$h{$e}{$ee}; 
    }
}

#   Farm..   Barn Date.of.collection              Farm.name
#     312              44318               Prairie Poultry
#   Outbreaks Date.of.collection                  Farm.name
#     23315         2019-07-01                 Eleet Farm

print OUT "\n";
close(IN1);
close(OUT);
exit;
