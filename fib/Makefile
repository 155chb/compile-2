.PHONY:test,clean
test:
	arm-linux-gnueabihf-gcc test.S -o test
	qemu-arm -L /usr/arm-linux-gnueabihf ./test
clean:
	rm -fr test