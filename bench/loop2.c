main () {
  register int a = 0;
  register int i = 0;
  register int s = 1;
  while (i <= 100000000) {
    a = a + s * i;
    i = i + 1;
    s = - s;
  }
  printf("%ld\n", a);
}
