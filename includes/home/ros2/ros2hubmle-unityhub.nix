{
  pkgs,
  pkgs-ros,
  ...
}:

let
  rosDistro = "humble";
  pname = "ros2humble-unityhub";
  version = pkgs.unityhub.version;
  rosEnv = pkgs-ros.rosPackages.${rosDistro}.buildEnv {
    paths = with pkgs-ros.rosPackages.${rosDistro}; [
      ros-base
    ];
  };

  ros2unityhub = pkgs.stdenv.mkDerivation {
    inherit pname version;

    src = pkgs.unityhub;

    nativeBuildInputs = [ pkgs.makeWrapper ];

    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out/bin $out/share/applications

      makeWrapper $src/bin/unityhub $out/bin/${pname} \
        --set LD_LIBRARY_PATH "${rosEnv}/lib:${rosEnv}/lib" \
        --set ROS_DISTRO "${rosDistro}" \
        --add-flags "%u"

      cat > $out/share/applications/${pname}.desktop <<EOF
      [Desktop Entry]
      Name=Unity Hub (ROS 2 Humble)
      GenericName=Game Engine with ROS 2 environment
      Exec=$out/bin/${pname} %u
      Icon=unityhub
      Terminal=false
      Type=Application
      Categories=Development;
      MimeType=x-scheme-handler/unityhub;
      EOF
    '';
  };
in
{
  home.packages = [ ros2unityhub ];
}
