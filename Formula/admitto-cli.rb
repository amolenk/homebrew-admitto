class AdmittoCli < Formula
  desc "Admitto CLI"
  homepage "https://github.com/amolenk/Admitto"
  url "https://github.com/amolenk/Admitto/archive/eb5edfe3a29a4a7092d7b485e05478d8073eaa9e.tar.gz"
  sha256 "d99dad5b7aca4f3c89baa7d92689917c359649c93198dfc78097e0c55ac3da1f"
  version "1.0.30"
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
        "Authority": "https://login.microsoftonline.com/3491bee1-dc92-4c78-9193-2209b34dc958/v2.0",
        "ClientId": "ffeca9b6-fa75-4f7d-bb30-feecb1ef0842",
        "Scope": "api://sandermolenkamp.com/admitto/Admin offline_access",
        "RequireHttps": true
      },
      "Admitto": {
        "Endpoint": "https://admitto.sandermolenkamp.com"
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
