export const yabai = "/run/current-system/sw/bin/yabai ";

export const closeWindow = `
window_pid=$(${yabai} -m query --windows --window | jq -r '.pid')
app_name=$(${yabai} -m query --windows --window | jq -r '.app')
count_pid=$(${yabai} -m query --windows | jq "[.[] | select(.pid == \${window_pid})] | length")

if [ "$app_name" = "Finder" ]; then
  # For Finder, just close the window without killing the process
  ${yabai} -m window --close
elif [ "$app_name" = "Discord" ]; then
  ${yabai} -m window --close
elif [ "$count_pid" -gt 1 ]; then
  ${yabai} -m window --close
else
  kill "\${window_pid}"
fi
`;
