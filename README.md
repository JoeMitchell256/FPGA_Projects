# FPGA_Projects
This repository contains the majority of my FPGA side projects and academic coursework

With regards to the CPU pipeline, I based it off of the MIPS instruction set architecture and used this book to help me better understand
the architecture:

Computer Organization and Design Fifth Edition : David A. Patterson , John L. Hennessy

As an addition to the RISC cpu pipeline design, I have ran synthesis using Synopsys Design Compiler and have recorded the results of the minimum timing for each stage:

IF -> 2.5ns
ID -> 7ns
EX -> 5ns
MEM -> 1.5ns

So, current the pipeline is running at the clock frequency of the longest stage of the pipeline, which is in this case ~143 Mhz

However, the pipeline is expected to grow especially in the longest stage. So what I propose to do after the full implementation is to split the longest stage ideally in half so that the next longest stage will increase the max. frequency. The target frequency is 100 Mhz, but my goal is 2 Ghz!

I have also added my C program that parses Verilog files to produce dimacs formatted CNF files.
I was very proud of the work I did to design this C program. It helped me understand how good the C programming language can be!
