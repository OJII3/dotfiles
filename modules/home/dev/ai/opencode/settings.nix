{
  permission = {
    bash = {
      "*" = "ask";
      "rm *" = "ask";
      "git *" = "allow";
      "cat *" = "allow";
      "ls" = "allow";
      "ls *" = "allow";
      "mkdir *" = "allow";
      "rg *" = "allow";
      "nr *" = "allow";
      "bun *" = "allow";
      "date *" = "allow";
      "gomi *" = "allow";
    };
    read = {
      ".dev.vars" = "deny";
    };
    "context7_*" = "allow";
  };

  mcp = {
    context7 = {
      enabled = true;
      type = "remote";
      url = "https://mcp.context7.com/mcp";
      headers = {
        CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
        Accept = "application/json, text/event-stream";
      };
    };
  };

  plugin = [
    "opencode-gemini-auth@latest"
    "@shun-shobon/opencode-caffeinate@latest"
  ];
}
