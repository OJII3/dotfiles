{
  permission = {
    bash = {
      "*" = "ask";
      "bun *" = "allow";
      "cat *" = "allow";
      "date *" = "allow";
      "git *" = "allow";
      "gomi *" = "allow";
      "ls *" = "allow";
      "ls" = "allow";
      "mkdir *" = "allow";
      "nr *" = "allow";
      "rg *" = "allow";
      "rm *" = "ask";
    };
    read = {
      ".dev.vars" = "deny";
      ".env" = "deny";
    };
    todoread = "allow";
    todowrite = "allow";
    glob = "allow";
    grep = "allow";
    webfetch = "allow";
    websearch = "allow";
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
  disabled_providers = [ "anthropic" ];
}
