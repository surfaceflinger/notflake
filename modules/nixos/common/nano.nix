{ inputs, lib, ... }:
{
  programs.nano = {
    enable = true;
    syntaxHighlight = true;
    nanorc = ''
      set autoindent
      set constantshow
      set indicator
      set linenumbers
      set minibar
      set nohelp
      set numbercolor normal,normal
      set tabsize 2
      set tabstospaces
      set titlecolor normal,normal
    '';
  };
  environment.etc.nanorc.text = lib.mkBefore "include ${inputs.nano-syntax-highlighting.result}/*.nanorc";
}
