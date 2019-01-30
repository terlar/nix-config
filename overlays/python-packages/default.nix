self: super:

{
  google-auth-oauthlib = super.callPackage ../../packages/google-auth-oauthlib { };
  screeninfo = super.callPackage ../../packages/screeninfo { };
}
