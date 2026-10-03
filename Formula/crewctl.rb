class Crewctl < Formula
  desc "Client for crewd: reads what a running daemon is doing over its ops API."
  homepage "https://github.com/StGerman/crewd"
  version "0.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/StGerman/crewd/releases/download/v0.1.0/crewctl-aarch64-apple-darwin.tar.xz"
    sha256 "6624d4fa299d4ae3f82649afb5978087c6435869a082246170298da20a87feb2"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/StGerman/crewd/releases/download/v0.1.0/crewctl-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "176703ad5473efb8299fa3baee5bbe5f054c791453aed142b3aa744f8137a4cc"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "crewctl"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "crewctl"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
