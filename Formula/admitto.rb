class Admitto < Formula
  desc "Admitto CLI"
  homepage "https://github.com/amolenk/Admitto"
  url "https://github.com/amolenk/Admitto/archive/3051b9eab88cce25c10ced998d1d3b54accd60f1.tar.gz"
  sha256 "c2cfaff710566a74c63c4836ca7186edc6474f461e49f8454510743543a2bc9f"
  version "1.0.12"
  license "MIT"

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