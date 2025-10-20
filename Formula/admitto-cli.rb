class AdmittoCli < Formula
  desc "Admitto CLI"
  homepage "https://github.com/amolenk/Admitto"
  url "https://github.com/amolenk/Admitto/archive/e864fe369a879d73d846a9e487c9f62057c75b86.tar.gz"
  sha256 "0e5278953519e1d392519547ac5039d2e4a79516d97f1a183b2c9f99874bd4c5"
  version "1.0.18"
  license "MIT+Commons Clause Restriction"

  # Requires .NET SDK to build
  depends_on "dotnet@9"

  def install

    (buildpath/"src/Admitto.Cli/appsettings.json").write <<~EOS
    {
      "Authentication": {
        "Authority": "https://login.microsoftonline.com/3491bee1-dc92-4c78-9193-2209b34dc958/v2.0",
        "ClientId": "ffeca9b6-fa75-4f7d-bb30-feecb1ef0842",
        "Scope": "api://sandermolenk.com/admitto/Admin offline_access",
        "RequireHttps": true
      },
      "Admitto": {
        "Endpoint": "https://admitto.sandermolenkamp.com"
      }
    }
    EOS

    project = "src/Admitto.Cli/Admitto.Cli.csproj"
    system "dotnet", "publish", project, "-c", "Release", "-o", "out",
           "-p:AssemblyVersion=#{version}", "-p:FileVersion=#{version}", "-p:InformationalVersion=#{version}"

    libexec.install Dir["out/*"]

    (bin/"admitto").write <<~EOS
      #!/bin/bash
      exec "#{Formula["dotnet@9"].opt_bin}/dotnet" "#{libexec}/Admitto.Cli.dll" "$@"
    EOS
    (bin/"admitto").chmod 0755

  end

end