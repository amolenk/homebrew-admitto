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
    # Publish app as framework-dependent (requires user to have .NET runtime)
    # Include the tarball sha256 in the informational version.
    system "dotnet", "publish", "-c", "Release", "-o", "out",
           "-p:AssemblyVersion=#{version}", "-p:FileVersion=#{version}", "-p:InformationalVersion=#{version}"

    # Install the executable into Homebrew’s bin dir
    bin.install "out/admitto"
  end

  test do
    system "#{bin}/admitto", "--version"
  end
end