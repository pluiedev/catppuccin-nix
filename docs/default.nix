nixpkgs: { nmd }: let
  hmModules = nmd.lib.buildModulesDocs {
    moduleRootPaths = [ ../modules/home-manager ];
    channelName = "catppuccin";
    docBook = {
      id = "hm-options";
    };
    mkModuleUrl = path: "https://github.com/catppuccin/nix/blob/main/modules/home-manager${path}#blob-path";
    modules = [ (import ../modules/home-manager nixpkgs) { _module.check = false; } ];
  };
  docs = nmd.lib.buildDocBookDocs {
    pathName = "catppuccin";
    projectName = "Catppuccin";
    # modulesDocs = [ hmModules ];
    documentsDirectory = ./.;
    chunkToc = ''
      <toc>
        <d:tocentry xmlns:d="http://docbook.org/ns/docbook" linkend="book-catppuccin-manual"><?dbhtml filename="index.html"?>
          <d:tocentry linkend="ch-hm-options"><?dbhtml filename="hm-options.html"?></d:tocentry>
        </d:tocentry>
      </toc>
    '';
  };
in
  docs.html
