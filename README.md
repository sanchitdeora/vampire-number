# Vampire Numbers

#### Group Members:

Sanchit Deora (8909 - 4939)  
Rohit Devulapalli (4787 - 4434)

## Problem definition

An interesting kind of number in mathematics is vampire number. A vampire number is a composite (Links to an external site.) natural number with an even number of digits, that can be factored into two natural numbers each with half as many digits as the original number and not both with trailing zeroes, where the two factors contain precisely all the digits of the original number, in any order, counting multiplicity.
A classic example is: 1260 = 21 x 60.
  
A vampire number can have multiple distinct pairs of fangs. A vampire numbers with 2 pairs of fangs is: 125460 = 204 × 615 = 246 × 510.
  
The overall goal of this project is to find all Vampire numbers starting at **first** upto **last** using Elixir and the Actor Model to build a good solution to this problem that runs well on multi-core machines.

### Actor modeling

In this project, we exclusively used the actor facility in Elixir. In particular, we defined worker actors that are given a range of problems to solve and a boss that keeps track of all the problems and perform the job assignment.

### Getting Started

Input: The input provided (as command line to your program, e.g. my_app) will be two numbers: **first** upto **last**. The overall goal of your program is to find all vampire numbers starting at **first** upto **last**.

Output: Print, on independent lines, first the number then its fangs. If there are multiple fangs list all of them next to each other.

### Instructions to run the code on Single machine

mix run proj1.exs first last.  
This command is for Windows OS.  
The format of output is number followed by it’s fangs displayed on the console. If the result is an empty set, there is no display.

### Instructions to run the code on Multiple remote machines

Ran on three machines, one external, one local node and one supervisor node

1. Launch an Erlang VM on each machine using *iex --name <node_name>@<node_ip_address> --cookie <cookie_name> -S mix*
2. Update **node_list** in **proj1_remote.exs**
3. On the supervisor node execute *elixir --name <supervisor_name>@<supervisor_ip_address> --cookie <cookie_name> -S mix run proj1_remote.exs first last *

### Number of Worker Actors created

The number of Worker Actors is created dynamically and is very specific to the range of numbers given as the input. In this program, the range is sent to a splitRange function on the main Worker Actor first. 
There it checks if the range is less than or equal to the designated range calculated dynamically as well. If it is greater than the designated range, it splits the range in half sending the first range into a new Worker Actor while the second range is passed to the same function which is called recursively on the same Worker Actor.

### Size of the work unit

The size of each work unit is calculated dynamically depending on the range it receives. Here it first checks the local range and counts the number of digits of **last** to decide if the numbers in the local range are small or large. These number of digits are used to generate a denominator **(:math.pow(10,number of digits))**. 
The range is calculated by dividing the global range(**last** - **first**) with the denominator generated. This gives us a larger size of the work unit when the local range has smaller number and smaller size of the work unit when the local range has larger numbers. 
This way it ensures that there is balance on the workload since it takes larger processing time for larger numbers.

### Result of running the program

![Images of Result (1)](https://github.com/sanchitdeora/vampire-number/blob/master/Images/output_for_100000_200000_1.PNG)

![Images of Result (2)](https://github.com/sanchitdeora/vampire-number/blob/master/Images/output_for_100000_200000_2.PNG)

![Images of Result (3)](https://github.com/sanchitdeora/vampire-number/blob/master/Images/output_for_100000_200000_3.PNG)

### Running Time for the application:

CPU time: 173765 ms  
Real time: 23797 ms  
Ratio time: 7.301970836660083  

### Largest problem that we managed to solve using a Single machine:

![Images of Largest Problem (1)](https://github.com/sanchitdeora/vampire-number/blob/master/Images/image1.png)

![Images of Largest Problem (2)](https://github.com/sanchitdeora/vampire-number/blob/master/Images/image2.png)

![Images of Largest Problem (3)](https://github.com/sanchitdeora/vampire-number/blob/master/Images/image3.png)

![Images of Largest Problem (4)](https://github.com/sanchitdeora/vampire-number/blob/master/Images/image4.png)

![Images of Largest Problem (5)](https://github.com/sanchitdeora/vampire-number/blob/master/Images/image5.png)

![Images of Largest Problem (6)](https://github.com/sanchitdeora/vampire-number/blob/master/Images/image6.png)

![Images of Largest Problem (7)](https://github.com/sanchitdeora/vampire-number/blob/master/Images/image7.png)
