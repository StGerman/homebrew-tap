class Crewd < Formula
  desc "Tracker-driven orchestrator for Claude Code agents: a worktree, a session and a pull request per issue. The `crew` library inside is internal, with no API promise."
  homepage "https://github.com/StGerman/crewd"
  version "0.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/StGerman/crewd/releases/download/v0.1.0/crewd-aarch64-apple-darwin.tar.xz"
    sha256 "57c94b1b0eb0ce61c34a0ff084d18a970d7b8eacaa9d687648cfaad6dfff3d29"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/StGerman/crewd/releases/download/v0.1.0/crewd-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "48471b7b5cc2537998c922dce8a737374def01f96c8e61f59a28fbdebe7b567a"
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
      bin.install "crewd"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "crewd"
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
