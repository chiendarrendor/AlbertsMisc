# this function takes the info about
# the two columns of letters in the aldridge puzzle
# and blocks of letters that need to be pulled
# this code will return all the different ways
# to pull those letters from the letter columns

$b = "amuptltekwmdeutskbfg";
$a = "bsynskddrwihwcmmcdim";

@blocks=
(
 "gbdm",
 "cuwe",
 "sfim",
 "cmkt"
);

# analysis:
# g -- b only
# b -- b only
# m -- a only
# d -- a only

$b = "amuptltekwmde utskf";
$a = "bsynskddrwihw cmmci";

# cuwe
# c -- a only
# u -- b only
# e -- b only (after u)
# w -- a only (after c)

$b = "amuptltekwm dtskf";
$a = "bsynskddrwi hmmci";

# sfim
# i -- a only
# f -- b only
# s -- b only
# m -- a or b

# sfim m-a
$b = "amuptltek wmdtk";
$a = "bsynskddr wihmc";

# cmkt
# c -- a only
# t -- b only
# k -- b only
# m -- a or b

# sfim m-b*
$b =   "amuptlte kwdtk";
$a = "bsynskddrw ihmmc";

# cmkt
# c -- a only
# t -- b only
# k -- b only
# m -- a only
