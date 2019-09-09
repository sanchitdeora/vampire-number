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

### Instructions to run the code

mix run proj1.exs first last.  
This command is for Windows OS.  
The format of output is number followed by it’s fangs displayed on the console. If the result is an empty set, there is no display.

### Number of Worker Actors created

The number of Worker Actors is created dynamically and is very specific to the range of numbers given as the input. In this program, the range is sent to a splitRange function on the main Worker Actor first. 
There it checks if the range is less than or equal to the designated range calculated dynamically as well. If it is greater than the designated range, it splits the range in half sending the first range into a new Worker Actor while the second range is passed to the same function which is called recursively on the same Worker Actor.

### Size of the work unit

The size of each work unit is calculated dynamically depending on the range it receives. Here it first checks the local range and counts the number of digits of **last** to decide if the numbers in the local range are small or large. These number of digits are used to generate a denominator **(:math.pow(10,number of digits))**. 
The range is calculated by dividing the global range(**last** - **first**) with the denominator generated. This gives us a larger size of the work unit when the local range has smaller number and smaller size of the work unit when the local range has larger numbers. 
This way it ensures that there is balance on the workload since it takes larger processing time for larger numbers.

### Result of running the program

C:\Users\sanch\IdeaProjects\vampire_numbers>mix run proj1.exs 100000 200000
180297 201 897
150300 300 501
124483 281 443
132430 323 410
117067 167 701
125460 204 615 246 510
110758 158 701
135837 351 387
126000 210 600
156240 240 651
129775 179 725
143500 350 410
118440 141 840
152608 251 608
153000 300 510
136525 215 635
135828 231 588
156289 269 581
146952 156 942
193945 395 491
197725 275 719
125433 231 543
125500 251 500
139500 150 930
192150 210 915
162976 176 926
105264 204 516
173250 231 750
175329 231 759
186624 216 864
123354 231 534
146137 317 461
126846 261 486
156915 165 951
116725 161 725
108135 135 801
125248 152 824
182650 281 650
174370 371 470
134725 317 425
105750 150 705
182250 225 810
190260 210 906
182700 210 870
133245 315 423
172822 221 782
136948 146 938
193257 327 591
145314 351 414
152685 261 585
126027 201 627
131242 311 422
115672 152 761
180225 225 801
153436 356 431
120600 201 600
129640 140 926
104260 260 401
105210 210 501
140350 350 401
163944 396 414
102510 201 510
CPU time: 173765 ms Real time: 23797 ms Ratio time: 7.301970836660083

### Running Time for the application:

**CPU time: 173765 ms**
**Real time: 23797 ms**
**Ratio time: 7.301970836660083**

### Largest problem that we managed to solve:

