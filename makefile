.PHONY: test

test:
	cutest ./test/*.rb

console:
	irb -r ./lib/nest