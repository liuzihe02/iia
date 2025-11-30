# Add shared templates folder to TeX input path
$ENV{'TEXINPUTS'} = '../templates//:' . ($ENV{'TEXINPUTS'} || '');
