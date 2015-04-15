.PHONY: test

test:
	prove -lr --exec=perl6 t
