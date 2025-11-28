{
  python3Packages,
  fetchPypi
}:

python3Packages.buildPythonApplication rec {
  pname = "bscpylgtv";
  version = "0.5.0";

  pyproject = true;
  build-system = with python3Packages; [ setuptools ];
  dependencies = with python3Packages; [ websockets sqlitedict ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oV2FwKi1nLwmcN7YbPHmJ56VuFCewD/SCGp7Y1txBBM=";
  };
}
