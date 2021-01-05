#include <stdlib.h>
#include <unistd.h>

#include <iostream>

#define CASE(D, X) case D: (X); break

extern char *__progname;

void usage(int exit_status) {
  std::cerr << __progname << " [-ehr] [-n number_of_password] [-l min_password_length] " << std::endl
            << "\t\t[-p distribution_parameter] [-m max_password_length]"
	    << "\t\t[-s password_length]" << std::endl;
  exit(exit_status);
}

char random_char(const bool number_only) {
  if (number_only)
    return (char) ('0' + arc4random_uniform(10));
  else
    return (char) (' ' + arc4random_uniform('~' - ' '));
}

int main(int argc, char *argv[]) {
  int ch;
  int min_passwd_len, max_passwd_len;
  int distribution_param;
  int nb_pass;

  bool display_end, help, random_len, number_only;

  display_end = help = random_len = number_only = false;
  min_passwd_len = max_passwd_len = 12;
  distribution_param = 4;
  nb_pass = 1;

  while ((ch = getopt(argc, argv, "dehn:m:l:p:rs:")) != -1)
    switch (ch) {
    CASE('d', number_only = true);
    CASE('e', display_end = true);
    CASE('h', help = true);
    CASE('n', nb_pass = atoi(optarg));
    CASE('m', max_passwd_len = atoi(optarg));
    CASE('l', min_passwd_len = atoi(optarg));
    CASE('p', distribution_param = atoi(optarg));
    CASE('r', random_len = true);
    CASE('s', max_passwd_len = min_passwd_len = atoi(optarg));
    default:
      usage(1);
    }

  if (help)
    usage(0);

  max_passwd_len = std::max(max_password_len, min_passwd_len);

  for (int j = 0; j < nb_pass; ++j) {
    for (int i = min_passwd_len + arc4random_uniform(max_passwd_len - min_passwd_len); i != 1; --i)
      std::cout << random_char(number_only);
    if (random_len)
      while (arc4random_uniform(distribution_param))
	std::cout << random_char(number_only);

    std::cout << (display_end ? "$" : "") << std::endl;
  }
}
