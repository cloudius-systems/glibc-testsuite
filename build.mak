
arch = x64
INCLUDES = -I. -I$(src)
CFLAGS = $(autodepend) -g -Wall -Wno-pointer-arith $(INCLUDES) -Werror $(cflags-$(mode)) \
	-D_GNU_SOURCE -U_FORTIFY_SOURCE -fno-stack-protector -fPIC \
	$(arch-cflags) 
ASFLAGS = -g $(autodepend)

cflags-debug =
cflags-release = -O2

arch-cflags = -msse4.1


quiet = $(if $V, $1, @echo " $2"; $1)
very-quiet = $(if $V, $1, @$1)

makedir = $(call very-quiet, mkdir -p $(dir $@))
build-c = $(CC) $(CFLAGS) -c -o $@ $<
q-build-c = $(call quiet, $(build-c), CC $@)
build-s = $(CXX) $(CXXFLAGS) $(ASFLAGS) -c -o $@ $<
q-build-s = $(call quiet, $(build-s), AS $@)
build-so = $(CC) $(CFLAGS) -o $@ $^
q-build-so = $(call quiet, $(build-so), CC $@)
	
%.o: %.c
	$(makedir)
	$(q-build-c)

%.o: %.S
	$(makedir)
	$(q-build-s)

%.so: CFLAGS+=-fPIC -shared
%.so: %.o
	$(makedir)
	$(q-build-so)

nptl/tst-mutex1.o: CFLAGS += -Wno-nonnull

tests :=
tests += io/tst-getcwd.so
tests += libio/test-fmemopen.so
tests += malloc/tst-malloc.so
tests += nptl/tst-mutex1.so \
	 nptl/tst-mutex2.so \
	 nptl/tst-mutex3.so \
	 nptl/tst-mutex4.so \
	 nptl/tst-mutex5.so \
	 nptl/tst-mutex5a.so \
	 nptl/tst-mutex6.so \
	 nptl/tst-mutex7.so \
	 nptl/tst-mutex7a.so \
	 nptl/tst-mutex8.so \
	 nptl/tst-mutex9.so
tests += rt/tst-clock.so

all: $(tests)

-include $(shell find -name '*.d')
