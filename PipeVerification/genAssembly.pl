#!/Users/jm/perl15/man/man3 -w
use Switch;
use warnings;
use strict;

#I wish to generate a random number from 0 to n where n is the number of instructions in my instruction set
#I also wish to generate a random number from 0 to 31 for all 32 different registers

#The ultimate goal of this program is to show that it is possible with the perl scripting language to generate a random assembly program for pipeline verification

#After this, if time permitted decompile this into c code and call gcc to run it and verify that all variables are their expected values comparable to the pipeline's variables

#According to my count there are 31 unique instructions available to execute

#Generate a random instruction from the instruction set:

my @array = ();

my $filename = '/Users/jm/Desktop/spim/example.asm';

open(FH,'<',$filename) or die $!;

my @lines = <FH>;

my $lineOffset = 19;

my $rs = 0;
my $rt = 0;
my $rd = 0;
my $str = ""; #String used to format mips assembly instructions
my $i = 0;
for( $i = 0; $i < 60; $i++){
	switch(int(rand(8))) { #Instead of rand 31, now we test rand(8)
		case 0 {
			push(@array,"add"); #Maybe instead of pushing now... Lets format this into a string with random temporary registers...
			$str = sprintf("        add \$t%d,\$t%d,\$t%d\n",int(rand(10)),int(rand(10)),int(rand(10))); #This should print an add instruction to the assembly file...
			#print FH $str
			$lines[$lineOffset] = $str;
			$lineOffset = $lineOffset + 1;
		}
		#case 1 { push(@array,"addi"); }
		#case 2 { push(@array,"addiu"); }
		#case 3 { push(@array,"addu"); }
		case 1 {
			push(@array,"and");
			$str = sprintf("        and \$t%d,\$t%d,\$t%d\n",int(rand(10)),int(rand(10)),int(rand(10)));
			#print FH $str
			$lines[$lineOffset] = $str;
			$lineOffset = $lineOffset + 1;
		}
		#case 5 { push(@array,"andi"); }
		#case 6 { push(@array,"beq"); }
		#case 7 { push(@array,"bne"); }
		#case 8 { push(@array,"j"); }
		#case 9 { push(@array,"jal"); }
		#case 10 { push(@array,"jr"); }
		#case 11 { push(@array,"lbu"); }
		#case 12 { push(@array,"lhu"); }
		#case 13 { push(@array,"ll"); }
		#case 14 { push(@array,"lui"); }
		#case 15 { push(@array,"lw"); }
		case 2 {
			push(@array,"nor");
			$str = sprintf("        nor \$t%d,\$t%d,\$t%d\n",int(rand(10)),int(rand(10)),int(rand(10)));
			#print FH $str
			$lines[$lineOffset] = $str;
			$lineOffset = $lineOffset + 1;
		}
		case 3 {
			push(@array,"or");
			$str = sprintf("        or \$t%d,\$t%d,\$t%d\n",int(rand(10)),int(rand(10)),int(rand(10)));
			#print FH $str
			$lines[$lineOffset] = $str;
			$lineOffset = $lineOffset + 1;
		}
		#case 18 { push(@array,"ori"); }
		case 4 {
			push(@array,"slt");
			$str = sprintf("        slt \$t%d,\$t%d,\$t%d\n",int(rand(10)),int(rand(10)),int(rand(10)));
			#print FH $str
			$lines[$lineOffset] = $str;
			$lineOffset = $lineOffset + 1;
		}
		#case 20 { push(@array,"slti"); }
		#case 21 { push(@array,"sltiu"); }
		#case 22 { push(@array,"sltu"); }
		case 5 {
			push(@array,"sll");
			$str = sprintf("        sll \$t%d,\$t%d,\$t%d\n",int(rand(10)),int(rand(10)),int(rand(10)));
			#print FH $str
			$lines[$lineOffset] = $str;
			$lineOffset = $lineOffset + 1;
		}
		case 6 {
			push(@array,"srl");
			$str = sprintf("        srl \$t%d,\$t%d,\$t%d\n",int(rand(10)),int(rand(10)),int(rand(10)));
			#print FH $str
			$lines[$lineOffset] = $str;
			$lineOffset = $lineOffset + 1;
		}
		#case 25 { push(@array,"sb"); }
		#case 26 { push(@array,"sc"); }
		#case 27 { push(@array,"sh"); }
		#case 28 { push(@array,"sw"); }
		case 7 {
			push(@array,"sub");
			$str = sprintf("        sub \$t%d,\$t%d,\$t%d\n",int(rand(10)),int(rand(10)),int(rand(10)));
			#print FH $str
			$lines[$lineOffset] = $str;
			$lineOffset = $lineOffset + 1;
		}
		#case 30 { push(@array,"subi"); }
	}
	#push(@array,int(rand(31))); # Represents random instruction from 0 to 30
}

open(FH,'>',$filename) or die $!;
print FH @lines;


#Now I need to translate these random numbers into assembly instruction names:

for( $i = 0; $i < 60; $i++){
	printf("Instruction %s\n",$array[$i]);
}

close(FH);
