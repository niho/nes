NAME=test

.PHONY : build clean

build: $(NAME).nes

test.o: test.asm
	ca65 -o $@ $^

$(NAME).nes: test.o
	ld65 -C nes.cfg -o $@ $^

clean:
	rm -f test.o
	rm -f $(NAME).nes
