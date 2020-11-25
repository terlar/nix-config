final: prev:

with builtins;

{
  python3 = prev.python3.override {
    packageOverrides = pyFinal: pyPrev: {
      boto3 = pyPrev.boto3.overridePythonAttrs (oldAttrs: rec {
        version = "1.16.21";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "04qb86i7z6m9h3kpyxp343p0m0x45biw7hbvx270ls8iim0n703s";
        };
      });

      botocore = pyPrev.botocore.overridePythonAttrs (oldAttrs: rec {
        version = "1.19.21";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "18785n40mz97qqn51dm12z4za49bywv33hliwxvfqw92rasmy1lg";
        };
      });

      rsa = pyPrev.rsa.overridePythonAttrs (oldAttrs: rec {
        version = "4.1.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 =
            "1a7245638fa914ed6196b5e88fa5064cd95c7e65df800ec5d4f288e2b19fb4af";
        };
      });
    };
  };

  awscli = prev.awscli.overridePythonAttrs (oldAttrs: rec {
    version = "1.18.181";
    src = oldAttrs.src.override {
      inherit version;
      sha256 = "0l1zkhzq76bxm5b2m41arpppalq0w4m5fwqaidfq451jz9f32f62";
    };

    propagatedBuildInputs = with final;
      with python3.pkgs; [
        botocore
        bcdoc
        s3transfer
        six
        colorama
        docutils
        rsa
        pyyaml
        groff
        less
      ];

    postPatch = ''
      substituteInPlace setup.py --replace "docutils>=0.10,<0.16" "docutils>=0.10"
      substituteInPlace setup.py --replace "colorama>=0.2.5,<0.4.4" "colorama>=0.2.5"
    '';
  });
}
