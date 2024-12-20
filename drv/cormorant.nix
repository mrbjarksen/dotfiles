{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "cormorant";
  version = "3.609";

  src = fetchFromGitHub {
    owner = "CatharsisFonts";
    repo = "Cormorant";
    rev = "5495f2d6814f3e0df31f41028e413daf6192bdb1";
    hash = "";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/truetype fonts/ttf/*.ttf

    runHook postInstall
  '';

  meta = with lib; {
    description = "The Cormorant Typeface Project";
    longDescription = "Cormorant is a free display type family developed by Christian Thalmann (Catharsis Fonts).";
    homepage = "https://github.com/CatharsisFonts/Cormorant";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ mrbjarksen ];
  };
}
