#include <stdlib.h>
#include <unistd.h>

#include <iostream>

#define CASE(D, X) case D: X; break

extern char *__progname;

void usage(int exit_status) {
  std::cerr << __progname << " [-aehr] [-n number_of_password] [-l min_password_length] " << std::endl
            << "\t\t[-p distribution_parameter] [-m max_password_length]"
	    << "\t\t[-s password_length]" << std::endl;
  exit(exit_status);
}

char random_char(const bool number, const bool alpha_num) {
  if (number)
    return (char) ('0' + arc4random_uniform(10));
  if (alpha_num) {
    int rdn = arc4random_uniform(10 + 26 + 26);
    if (rdn < 10)
      return rdn + '0';
    if (rdn - 10 < 26)
      return rdn - 10 + 'a';
    return rdn - 10 - 26 + 'A';
  }
  return (char) (' ' + arc4random_uniform('~' - ' '));
}

int main(int argc, char *argv[]) {
  int ch;
  int min_passwd_len, max_passwd_len;
  int distribution_param;
  int nb_pass;

  bool display_end, help, random_len, alpha_num_only, number_only;

  display_end = help = random_len = number_only = alpha_num_only = false;
  min_passwd_len = max_passwd_len = 12;
  distribution_param = 4;
  nb_pass = 1;

  while ((ch = getopt(argc, argv, "adehn:m:l:p:rs:")) != -1)
    switch (ch) {
      CASE('a', alpha_num_only = true; number_only = false);
      CASE('d', alpha_num_only = false; number_only = true);
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

  max_passwd_len = std::max(max_passwd_len, min_passwd_len);

  for (int j = 0; j < nb_pass; ++j) {
    for (int i = min_passwd_len + arc4random_uniform(max_passwd_len - min_passwd_len); i != 1; --i)
      std::cout << random_char(number_only, alpha_num_only);
    if (random_len)
      while (arc4random_uniform(distribution_param))
	std::cout << random_char(number_only, alpha_num_only);

    std::cout << (display_end ? "$" : "") << std::endl;
  }
}
