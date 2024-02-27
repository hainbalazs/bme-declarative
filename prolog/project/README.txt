Content:

ksatrak.pl            Prolog framework
prolog_idok.txt       Prolog runtimes
README.txt            Description (this file)
tests/                Test cases and solutions

The instructions for using the framework are included in the Project printout, see
on the DP website.

The runtimes were measured using an algorithm we considered to be relatively fast,
with a time limit of 2 minutes per task on a machine of the following type:
  model name : Intel(R) Core(TM) i5-3230M CPU @ 2.60GHz

The program to solve the problem was added to the ksatrak.pl file and the tests folder
(in the same folder) as satrak.pl.

In the same folder, issue the following command to run the measurement:

  sicstus --nologo --noinfo -l ksatrak.pl --goal 'total_test(120),halt.'

Here, the complete_test(timeout) procedure is used to timeout all the
"testXXXd.txt" test files

- runs the test with a timeout of seconds,

- checks that the timeout time specified in ./tests/testXXXs.txt
  solution set in the test file,

- prints the solution list and the result in readable form
  result in the tests_out_pl folder testXXXt.txt.

The number XXX in the file name can be of any length.

The tests folder contains 36 test cases. On submission, these are listed in a
subset of the programs, this subset is the following:

tests library name         name to be displayed when testing

test07d.txt                test0d.txt
test10d.txt                test1d.txt
test17d.txt                test2d.txt
test18d.txt                test3d.txt
test19d.txt                test4d.txt
test20d.txt                test5d.txt
test23d.txt                test6d.txt
test24d.txt                test7d.txt
test28d.txt                test8d.txt
test29d.txt                test9d.txt
		    

