class AdmittoCli < Formula
  desc "Admitto CLI"
  homepage "https://github.com/amolenk/Admitto"
  url "https://github.com/amolenk/Admitto/archive/7b3a5a4cd927b113db61dd20b287921f82d771a6.tar.gz"
  sha256 "761255cac64948d1db12557278534f348b25fe7856faaa7b9a52afe5704a15ea"
  version "1.0.22"
  license "MIT+Commons Clause Restriction"

  # Requires .NET SDK to build
  depends_on "dotnet@9"

  def install
    cli_dir = buildpath/"src/Admitto.Cli"
    cli_dir.mkpath

    target = cli_dir/"appsettings.json"
    target.unlink if target.exist?   # remove any existing file so we can overwrite

    target.write <<~EOS
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

    project = cli_dir/"Admitto.Cli.csproj"
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