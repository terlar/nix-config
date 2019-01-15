self: super: {
  python37 = super.python37.override {
    packageOverrides = self: super: {
      google-auth-oauthlib = super.callPackage ../packages/google-auth-oauthlib { };
    };
  };
}
