class Admitto < Formula
  desc "Admitto CLI"
  homepage "https://github.com/amolenk/Admitto"
  url "https://github.com/amolenk/Admitto/archive/8ff5388000a711975d204d83d776204754d1eb4f.tar.gz"
  sha256 "016b4daa4dc3f51c6305afc78f851d568e299fb081d721f582f3fe64f5c177ef"
  version "1.0.16"
  license "MIT+Commons Clause Restriction"

  # Requires .NET SDK to build
  depends_on "dotnet@9"

  def install
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