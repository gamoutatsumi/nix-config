{
  upkgs,
  ...
}:
{
  programs = {
    emacs = {
      enable = true;
      package = upkgs.emacsWithPackagesFromUsePackage {
        package =
          if upkgs.stdenv.isLinux then
            upkgs.emacs-unstable
          else
            upkgs.emacs-unstable.override { withNativeCompilation = false; };
        config = ./init.el;
        defaultInitFile = true;
        extraEmacsPackages =
          epkgs: with epkgs; [
            (treesit-grammars.with-grammars (
              p: with p; [
                # keep-sorted start
                tree-sitter-bash
                tree-sitter-c
                tree-sitter-c-sharp
                tree-sitter-cmake
                tree-sitter-css
                tree-sitter-dockerfile
                tree-sitter-elisp
                tree-sitter-go
                tree-sitter-html
                tree-sitter-javascript
                tree-sitter-json
                tree-sitter-make
                tree-sitter-markdown
                tree-sitter-markdown-inline
                tree-sitter-nix
                tree-sitter-python
                tree-sitter-ruby
                tree-sitter-rust
                tree-sitter-scss
                tree-sitter-toml
                tree-sitter-tsx
                tree-sitter-typescript
                tree-sitter-yaml
                # keep-sorted end
              ]
            ))
          ];
      };
    };
  };
}
