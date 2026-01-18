class AdmittoCli < Formula
  desc "Admitto CLI"
  homepage "https://github.com/amolenk/Admitto"
  url "https://github.com/amolenk/Admitto/archive/38a0e349c3bc94443ea7551a94141a513384577d.tar.gz"
  sha256 "64fd971cdb08e4a81a0b511f2605bbd94d52303f8276461505b832bb6d637ed6"
  version "1.0.46"
  license "MIT+Commons Clause Restriction"

  def install

    # allow Homebrew's build environment to find dotnet installed with the official macOS installer
    ENV.prepend_path "PATH", "/usr/local/bin"
    ENV.prepend_path "PATH", "/usr/local/share/dotnet"

    # make the error actionable if dotnet is not installed on the machine
    unless Utils.which("dotnet")
    odie "Building Admitto CLI requires the .NET SDK (dotnet).\n" \
         "Install it from https://dotnet.microsoft.com/download."
    end

    cli_dir = buildpath/"src/Admitto.Cli"
    cli_dir.mkpath

    target = cli_dir/"appsettings.json"
    target.unlink if target.exist?   # remove any existing file so we can overwrite

    target.write <<~EOS
    {
      "Authentication": {
        "Authority": "https://login.admitto.org/ed147a87-473b-43b4-ad35-e42e886c65d6/v2.0",
        "ClientId": "1b5865c0-6cb7-4c35-a31b-ec8fac8ef0e9",
        "Scope": "api://admitto.org/manage offline_access",
        "RequireHttps": true,
        "VerificationUri": "https://login.admitto.org/common/oauth2/deviceauth"
      },
      "Admitto": {
        "Endpoint": "https://api.admitto.org"
      }
    }
    EOS

    project = cli_dir/"Admitto.Cli.csproj"
    system "dotnet", "publish", project, "-c", "Release", "-o", "out",
           "-p:AssemblyVersion=#{version}", "-p:FileVersion=#{version}", "-p:InformationalVersion=#{version}"

    libexec.install Dir["out/*"]

    (bin/"admitto").write <<~EOS
      #!/bin/bash
      exec "dotnet" "#{libexec}/Admitto.Cli.dll" "$@"
    EOS
    (bin/"admitto").chmod 0755

  end

end
