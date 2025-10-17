class Admitto < Formula
  desc "Admitto CLI"
  homepage "https://github.com/amolenk/Admitto"
  url "PUT_URL_OF_TARBALL_HERE"
  sha256 "PUT_SHA256_OF_TARBALL_HERE"
  version "PUT_VERSION_NUMBER_HERE"
  commit "PUT_GIT_COMMIT_HASH_HERE"
  license "MIT"

  # Requires .NET SDK to build
  depends_on "dotnet@9"

  # Publish app as framework-dependent (requires user to have .NET runtime)
  # Include the tarball sha256 in the informational version.
  system "dotnet", "publish", "-c", "Release", "-o", "out",
        "-p:AssemblyVersion=#{version}", "-p:FileVersion=#{version}", "-p:InformationalVersion=#{version}-#{commit}"

  # Install the executable into Homebrew’s bin dir
  bin.install "out/admitto"

  test do
    system "#{bin}/admitto", "--version"
  end
end