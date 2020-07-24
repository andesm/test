main () {
  register unsigned long a = 0;
  register unsigned long i = 0;
  while (i <= 100000000) {
    a = a + i;
    i = i + 1;
  }
  printf("%ld\n", a);
}
