all:
        git add .
	nix build
	python -m http.server --directory result
