all:
	nix build
	python -m http.server --directory result
