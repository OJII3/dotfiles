# SNMP daemon configuration
# Provides SNMP monitoring for network management systems
#
{ config, lib, ... }:
let
  cfg = config.dot.networking.snmpd;
in
{
  config = lib.mkIf cfg.enable {
    services.snmpd = {
      enable = true;
      openFirewall = true;

      configText = ''
        # Change RANDOMSTRINGGOESHERE to your preferred SNMP community string
        com2sec readonly  default         RANDOMSTRINGGOESHERE

        group MyROGroup v2c        readonly
        view all    included  .1                               80
        access MyROGroup ""      any       noauth    exact  all    none   none

        syslocation Rack, Room, Building, City, Country [GPSX,Y]
        syscontact Your Name <your.email@example.com>

        # OS Distribution Detection
        extend distro /usr/bin/distro

        # Hardware Detection (uncomment to enable)
        # For x86 platforms:
        #extend hardware '/bin/cat /sys/devices/virtual/dmi/id/product_name'
        #extend manufacturer '/bin/cat /sys/devices/virtual/dmi/id/sys_vendor'
        #extend serial '/bin/cat /sys/devices/virtual/dmi/id/product_serial'

        # For ARM platforms (like Raspberry Pi):
        #extend hardware '/bin/cat /sys/firmware/devicetree/base/model'
        #extend serial '/bin/cat /sys/firmware/devicetree/base/serial-number'
      '';
    };
  };
}
