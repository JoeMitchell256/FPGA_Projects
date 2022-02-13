#include <stdio.h>
#include <stdlib.h>
#include <string.h>



#define BUFF 3000

char* variables[BUFF] = {};

int main(int argc, char* argv[])
{
    memset(variables, 0, BUFF * sizeof(char *));

    //Step 1: Read command line arguments from terminal

    //This is what the below line did...
    //printf("The user entered this file: %s \nThe user entered this number of loop unrolls: %d\nThe user entered this target state: %s \n",
    //  argv[1],atoi(argv[2]),argv[3]);

    //Step 2: Open two file descriptors, one for writing and one for reading

    FILE* fp = fopen(argv[1],"r");
    FILE* fpd = fopen("dimacs","a");

    //Step 3: Count how many 'and' and 'not' keywords there are and output the total number of clauses

    char* line = NULL;
    char* token = NULL;
    char line_backup[300000];//Some lines can be loooong!
    size_t len = 0;
    ssize_t read;


    int ands = 0;
    int nots = 0;

    //This block of code finds lines that only contain the four keywords listed
    while( (read = getline(&line, &len, fp)) != -1){
      //It is safe to split the line by spaces to start since every line has spaces...
      token = strtok(line," ");
      while(token != NULL){
        if(strcmp(token,"and") == 0){//We split the line because its not good enough to use strstr() function since there are comments in verilog
          ands++;
        }
        if(strcmp(token,"not") == 0){
          nots++;
        }
        token = strtok(NULL," ");
      }
    }


    //The number of logic clauses are 3 for each and + 2 for each not multiplied by total number of loop unrollings
    int logic_c = (3 * ands + 2 * nots) * atoi(argv[2]);
    //The number of buffer clauses are equual to the number of loop unrollings - 1 multiplied by the number of state bits
    int buf_c = 2 * (atoi(argv[2])-1) * (strlen(argv[3]));



    //Step 4: Close fd and reopen to reset the file pointer to beginning of verilog file

    int var_count = 0;
    int dupFlag = 0;
    int i = 0;

    fclose(fp);

    fp = fopen(argv[1],"r"); //Open the fd for reading the verilog file again...

    //Step 5: Read all variables. (Try not to read the same variable more than once)

    while( (read = getline(&line, &len, fp)) != -1){
      //It is safe to split the line by spaces to start since every line has spaces...
      token = strtok(line," ");
      while(token != NULL){
        if(strcmp(token,"input") == 0 || strcmp(token,"output") == 0 || strcmp(token,"reg") == 0 || strcmp(token,"wire") == 0){//We split the line because its not good enough to use strstr() function since there are comments in verilog
          //This line has potential for inputs
          token = strtok(NULL," ");//Now split by space again to get the right side of the string
          token = strtok(token,";");//Split by semicolon because every line has a semicolon
          if(strstr(token,",") >= 0){
            token = strtok(token,",");
          }
          while(token != NULL){
            for(i = 0; i < var_count; i++){
              if(strcmp(variables[i],token) == 0){ //We already have this variable!!!
                dupFlag = 1;
              }
            }
            if(strstr(token,",") == 0 && strcmp(token,"clock") != 0 && !dupFlag){//All inputs besides clock!
              variables[var_count] = malloc(strlen(token) + 1); //Allocate memory...
              strcpy(variables[var_count],token);
              var_count++;
            }
            token = strtok(NULL,",");
            dupFlag = 0;//Reset duplication flag
          }
        }
        token = strtok(NULL," ");
      }
    }

    //Variables are all accounted for at this point! (With no duplicates!)


    //Step 6 : Determine the number of variables and then print the first line of the dimacs formatted cnf file

    int total_var = var_count * atoi(argv[2]);

    fprintf(fpd,"p cnf %d %d\n",total_var,(logic_c + buf_c + 2*(strlen(argv[3]))) ); // Last segment is accounts for the initial and target states

    //Step 9 : Add the initial conditions to the dimacs formatted cnf file!

    int nextStates[strlen(argv[3])]; //We have the same number of state bits as user provides to the target state.
    int currentStates[strlen(argv[3])]; //We have the same number of state bits as the user provides us...
    char next[50];
    char curr[50];

    //We are first going to parse through the variables to find all of the next states.
    for(i = strlen(argv[3]) - 1; i >= 0; i--){
      sprintf(next,"NS%d",i);
      sprintf(curr,"S%d",i);
      for(dupFlag = 0; dupFlag < var_count; dupFlag++){
        if(strcmp(variables[dupFlag],next) == 0){
          nextStates[i] = dupFlag; //The next state's index starting big endian
        }
        if(strcmp(variables[dupFlag],curr) == 0){
          currentStates[i] = dupFlag; //The current state's index starting big endian
        }
      }
    }


    fprintf(fpd, "c Add our initial state clauses\n");

    //Our initial state is always presumed to be 0
    for(i = 0; i < strlen(argv[3]); i++){ // Make sure we enfore all of the current state conditions
      fprintf(fpd, "-%d 0\n",currentStates[i] + 1);//Print the initial conditions ; which are all indices!!!
    }

    fprintf(fpd, "c Add our target state clauses\n");

    for(i = strlen(argv[3]) - 1; i >= 0; i--){// Remember that these were all represented as indices!!!
      if(argv[3][i] == '0'){ //If the current state
        fprintf(fpd, "-%d 0\n",nextStates[strlen(argv[3]) - 1 - i] + (atoi(argv[2])-1)*var_count  + 1); //This will get me the 0th index, 1st index, ....
      }else{
        fprintf(fpd, "%d 0\n",nextStates[strlen(argv[3]) - 1 - i] + (atoi(argv[2])-1)*var_count   + 1); //This will get me the 0th index, 1st index, ....
      }
    }

    //Step 8 : Parse the verilog file one more time and write both the and and not gates to dimacs formatted cnf

    int j = 0; //For counting the number of arguments to the particular gate...
    int output,input,input2; //Use position1 and position 2 for not gate, add position 3 for and gate

    for(j = 0; j < atoi(argv[2]); j++){//Do j number of unrollings,  Ask ourselves the serious question: How is j going to affect the indices?
      fclose(fp);

      fprintf(fpd, "c Add our logic clauses: %d\n",j+1);

      fp = fopen(argv[1],"r"); //Open the fd for reading the verilog file again...

      while( (read = getline(&line, &len, fp)) != -1){
        //It is safe to split the line by spaces to start since every line has spaces...
        token = strtok(line," ");
        while(token != NULL){
          if(strcmp(token,"and") == 0){//We split the line because its not good enough to use strstr() function since there are comments in verilog
            //loop through your variables.
            //I think we can split on space again, then split on semicolon, then ( and ) . We want to be left with just the parameters
            token = strtok(NULL," ");
            token = strtok(token,";");
            token = strtok(token,"(");
            token = strtok(NULL,"(");
            token = strtok(token,")");
            //printf("Here is the argument order for the and: %s\n",token);
            token = strtok(token,",");//We have the output

            for(i = 0; i < var_count; i++){
              if(strcmp(token,variables[i]) == 0){
                output = i + 1 + j*var_count; //We have found the output index!!!!
              }
            }

            token = strtok(NULL,",");//We have the first input

            for(i = 0; i < var_count; i++){
              if(strcmp(token,variables[i]) == 0){
                input = i + 1 + j*var_count; //We have found the output index!!!!
              }
            }

            token = strtok(NULL,",");//We have the final input!!!    I'm so glad I came up with this super cool method! My old method was horrible!

            for(i = 0; i < var_count; i++){
              if(strcmp(token,variables[i]) == 0){
                input2 = i + 1 + j*var_count; //We have found the output index!!!!
              }
            }

            //Now we can write the form in dimacs format!

            fprintf(fpd,"%d -%d 0\n",input,output);
            fprintf(fpd,"%d -%d 0\n",input2,output);
            fprintf(fpd,"-%d -%d %d 0\n",input,input2,output);

          }
          if(strcmp(token,"not") == 0){

            token = strtok(NULL," ");
            token = strtok(token,";");
            token = strtok(token,"(");
            token = strtok(NULL,"(");
            token = strtok(token,")");
            token = strtok(token,",");// Extract output

            for(i = 0; i < var_count; i++){
              if(strcmp(token,variables[i]) == 0){
                output = i + 1 + j*var_count; //We have found the output index!!!!
              }
            }

            token = strtok(NULL,","); // Extract input

            for(i = 0; i < var_count; i++){
              if(strcmp(token,variables[i]) == 0){
                input = i + 1 + j*var_count; //We have found the output index!!!!
              }
            }

            fprintf(fpd, "-%d -%d 0\n", output, input);
            fprintf(fpd, "%d %d 0\n", output, input);

          }
          token = strtok(NULL," ");
        }

      }
      fprintf(fpd, "c Add buffers %d\n",j);
      if(j != atoi(argv[2]) - 1){
        fprintf(fpd, "c Add buffers for unrolling\n");
        for(i = 0; i < strlen(argv[3]); i++){
          fprintf(fpd, "-%d %d 0\n" , nextStates[i] + (j)*var_count + 1, currentStates[i] + (j+1)*var_count + 1);//Both of these lines were slightly wrong!!!
          fprintf(fpd, "-%d %d 0\n" , currentStates[i] + (j+1)*var_count + 1, nextStates[i] + (j)*var_count + 1);//Both lines wrong again...
        }
      }

    }

    fclose(fp);
    fclose(fpd);

    return 0;
}
