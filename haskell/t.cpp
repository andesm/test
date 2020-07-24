#include <iostream>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unordered_map>

using namespace std;  

unordered_map<int, unordered_map<int, int>> m;
unordered_map<int, int> t;

unordered_map<int, int> f(int i, unordered_map<int, int> a)
{
  a[i] = 5;
  return a;
}


int main()
{
  for (int x = 0; x < 1000; x++) {
    for (int y = 0; y < 1000; y++) {
      m[x][y] = 1;
    }
  }

  int s = 0;
  for (auto x = m.begin(); x != m.end(); x++) {
    for (auto y = x->second.begin(); y != x->second.end(); y++) {
      s += y->second;
    }
  }

  for (int i = 0; i < 3; i++) {
    unordered_map<int, int> r;
    if (r.begin() == r.end()) {
      printf("no\n");
    }
    r = f(i, r);
    if (r.begin() != r.end()) {
      printf("yes\n");
    }
    printf("%d %d %d\n", r[0], r[1], r[2]);
  }
}
