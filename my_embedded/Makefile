#filename: Makefile
#Ryan Robucci
#Edit the first two lines as needed
#assumes source is main.c
TARGET = custom_component_test
IP = 169.254.167.163
#
ALT_DEVICE_FAMILY ?= soc_cv_av
CROSS_COMPILE = arm-none-linux-gnueabihf-
#CFLAGS = -std=gnu99 -static -g -pg -Wall  -I${SOCEDS_DEST_ROOT}/ip/altera/hps/altera_hps/hwlib/include -I${SOCEDS_DEST_ROOT}/ip/altera/hps/altera_hps/hwlib/include/$(ALT_DEVICE_FAMILY) -D$(ALT_DEVICE_FAMILY)
CFLAGS = -std=gnu99 -static -g -pg -Wall  -I${SOCEDS_DEST_ROOT}/ip/altera/hps/altera_hps/hwlib/include -Iip/altera/hps/altera_hps/hwlib/include/$(ALT_DEVICE_FAMILY) -D$(ALT_DEVICE_FAMILY)
LDFLAGS =  -static -g -pg -Wall
CC = $(CROSS_COMPILE)gcc
ARCH= arm
DEPS = *.h


build: $(TARGET)
$(TARGET): main.o
	$(CC) $(LDFLAGS)   $^ -o $@  
%.o : %.c $(DEPS) 
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f $(TARGET) *.a *.o *~ 

scp: build
	scp $(TARGET) root@$(IP):

