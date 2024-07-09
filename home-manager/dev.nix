{ pkgs, ... }: {
	home.packages = with pkgs; [
    gcc
    cmake
    go
    rye 
    typst
  ];
}
    
