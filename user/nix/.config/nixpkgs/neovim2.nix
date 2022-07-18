{ pkgs, lib }:
let 
  vimUtils = pkgs.vimUtils;
  in
  rec {
    getName = url:
        (builtins.match "(.+)/([^\/]+)\/?" url);
      
    getPackageName = pkg:
    let regex = "[^:]+://[^/]+/([^/]+?)/([^/]+?)/.*";
	url = pkg.src.url or (throw "Package ${pkg.name} does not contain src.url");
    in
      builtins.concatStringsSep "/" (builtins.match regex url);

    genTable = packages:
      "return  [" +  builtins.concatStringsSep ",\n" (builtins.map (pkg: "['${getPackageName pkg}'] = '${pkg.outPath}' ") packages) + "]";

    plugin = { repo, ref ? "HEAD" }:
      let
        splited = getName repo;
        owner = builtins.elemAt splited 0;
        repoName = builtins.elemAt splited 1;
      in vimUtils.buildVimPlugin {
        pname = "${lib.strings.sanitizeDerivationName repo}";
        version = ref;
        src = pkgs.fetchFromGitHub {
          inherit owner;
          repo = repoName;
        	rev = ref;
        };
      };

    mkTranslationTable = packages:
      pkgs.writeTextFile { name="neovim-nix-paths.lua"; text=(genTable packages); };
  }
  
