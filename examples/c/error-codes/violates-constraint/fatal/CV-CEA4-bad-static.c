// Copyright (c) 2015 Runtime Verification, Inc. (RV-Match team). All Rights Reserved.

int main() {
  int x = 0;
  int *y = &x;
  y = x - y;
  return 0;
}
