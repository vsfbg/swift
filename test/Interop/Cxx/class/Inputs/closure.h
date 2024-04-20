#ifndef __CLOSURE__
#define __CLOSURE__

struct NonTrivial {
  NonTrivial() { p = new int(123); }
  ~NonTrivial() { delete p; }
  NonTrivial(const NonTrivial &other) {
    p = new int(*other.p);
  }
  int *p;
};

void cfunc(void (^ _Nonnull block)(NonTrivial)) {
  block(NonTrivial());
}

void cfunc2(void (*fp)(NonTrivial)) {
  (*fp)(NonTrivial());
}

struct ARCWeak {
  __weak _Nullable id m;
};

void cfuncARCWeak(void (^ _Nonnull block)(ARCWeak)) {
  block(ARCWeak());
}

void cfunc(NonTrivial);
void cfuncARCWeak(ARCWeak);

#endif // __CLOSURE__
