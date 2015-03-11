require.config
  baseUrl: "js/",
  paths:
    "jquery": "https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery"
    "mousewheel": "https://cdnjs.cloudflare.com/ajax/libs/jquery-mousewheel/3.1.12/jquery.mousewheel"
    "paper": "https://cdnjs.cloudflare.com/ajax/libs/paper.js/0.9.21/paper-core"
    "resemble": "../lib/resemble"
  shim:
    "resemble":
      exports: "resemble"