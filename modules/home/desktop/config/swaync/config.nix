{ ... }: {
  services.swaync = {
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "application";
      control-center-margin-top = 0;
      control-center-margin-bottom = 0;
      control-center-margin-right = 0;
      control-center-margin-left = 0;
      notification-2fa-action = true;
      notification-inline-replies = false;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      widgets = [ "inhibitors" "title" "dnd" "notifiations" "mpris" ];
      widget-config = {
        mpris = {
          image-size = 96;
          image-radius = 12;
        };
      };
    };
    style = builtins.readFile ./style.css;
  };
}
