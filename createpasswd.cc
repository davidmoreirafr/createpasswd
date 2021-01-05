#include <stdlib.h>
#include <unistd.h>

#include <iostream>

#define CASE(D, X) case D: X; break

extern char *__progname;

void usage(int exit_status) {
  std::cerr << __progname << " [-aehr] [-n number_of_password] [-l min_password_length] " << std::endl
            << "\t\t[-p distribution_parameter] [-m max_password_length]" << "\t\t[-s password_length]" << std::endl;
  exit(exit_status);
}

char random_char(const bool number, const char type_generator) {
  if (number)
    return (char) ('0' + arc4random_uniform(10));
  if (type_generator == 'a') {
    int rdn = arc4random_uniform(10 + 26 + 26);
    if (rdn < 10)
      return rdn + '0';
    if (rdn - 10 < 26)
      return rdn - 10 + 'a';
    return rdn - 10 - 26 + 'A';
  }
  else if (type_generator == 'i') {
    int rdn = arc4random_uniform(16);
    if (rdn < 10)
      return rdn + '0';
    return rdn - 10 + 'a';
  }
  return (char) (' ' + arc4random_uniform('~' - ' '));
}

int main(int argc, char *argv[]) {
  int ch;
  unsigned min_passwd_len, max_passwd_len;
  unsigned distribution_param;
  int nb_pass;

  bool display_end, help, random_len, number_only;
  char type_generator;

  display_end = help = random_len = number_only = false;
  min_passwd_len = max_passwd_len = 12;
  distribution_param = 4;
  nb_pass = 1;
  type_generator = 0;

  while ((ch = getopt(argc, argv, "adehin:m:l:p:rs:")) != -1)
    switch (ch) {
      CASE('a', type_generator = 'a'; number_only = false);
      CASE('d', type_generator = 0; number_only = true);
      CASE('e', display_end = true);
      CASE('h', help = true);
      CASE('i', type_generator = 'i'; number_only = false);
      CASE('n', nb_pass = atoi(optarg));
      CASE('m', max_passwd_len = atoi(optarg));
      CASE('l', min_passwd_len = atoi(optarg));
      CASE('p', distribution_param = atoi(optarg));
      CASE('r', random_len = true);
      CASE('s', max_passwd_len = min_passwd_len = atoi(optarg));
    default: usage(1);
    }

  if (help) usage(0);

  if (max_passwd_len < min_passwd_len) std::swap(max_passwd_len, min_passwd_len);

  for (int j = 0; j < nb_pass; ++j) {
    for (int i = min_passwd_len + arc4random_uniform(max_passwd_len - min_passwd_len); i != 0; --i)
      std::cout << random_char(number_only, type_generator);
    if (random_len)
      while (arc4random_uniform(distribution_param))
	std::cout << random_char(number_only, type_generator);

    std::cout << (display_end ? "$" : "") << std::endl;
  }
}
