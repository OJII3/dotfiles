{ pkgs, ... }: {
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-skk
    ];
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-emoji
      twitter-color-emoji
      source-han-sans
      source-han-serif
      jetbrains-mono
      hackgen-nf-font
      nerdfonts
      migu
    ];
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif CJK JP" "Noto Color Emoji" ];
        sansSerif = [ "Noto Sans CJK JP" "Noto Color Emoji" ];
        monospace = [ "JetBrainsMono Nerd Font" "Noto Color Emoji" ];
        emoji = [ "Noto Color Emoji" ];
      };
      # in steam, use Migu 1P font for compatibility
      localConf = ''
        <?xml version="1.0"?>
         <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
         <fontconfig>
           <description>Change default fonts for Steam client</description>
           <match>
             <test name="prgname">
               <string>steamwebhelper</string>
             </test>
             <test name="family" qual="any">
               <string>sans-serif</string>
             </test>
             <edit mode="prepend" name="family">
               <string>Migu 1P</string>
             </edit>
           </match>
         </fontconfig>
      '';
    };
  };
}
