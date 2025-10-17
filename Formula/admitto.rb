class Admitto < Formula
  desc "Admitto CLI"
  homepage "https://github.com/amolenk/Admitto"
  url "https://github.com/amolenk/Admitto/archive/376e0009de7430e312946fa3d81e812bf56f4022.tar.gz"
  sha256 "ae161b2cd4cbbce6ef996e227619763793f2bbe1de9bbe9ab4ba68dc5304e227"
  version "1.0.13"
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