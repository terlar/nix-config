{ lib, bundlerEnv, ruby, bundlerUpdateScript }:

bundlerEnv {
  pname = "rufo";

  inherit ruby;

  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "rufo";

  meta = with lib; {
    description = "An opinionated ruby formatter";
    homepage = "https://docs.rubocop.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ terlar ];
    platforms = platforms.unix;
  };
}
