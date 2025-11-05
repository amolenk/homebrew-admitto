class AdmittoCli < Formula
  desc "Admitto CLI"
  homepage "https://github.com/amolenk/Admitto"
  url "https://github.com/amolenk/Admitto/archive/abb6b22a3f6d760af30204ceab76795fc62d0140.tar.gz"
  sha256 "c8aa0a2b35e7196606f0a1c4a77e2d07593c3db778ce6d14df033cddeae87412"
  version "1.0.28"
  license "MIT+Commons Clause Restriction"

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
