class Dug < Formula
  desc "macOS-native DNS lookup utility using the system resolver"
  homepage "https://github.com/shortrib-labs/dug"
  url "https://github.com/shortrib-labs/dug/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "b102e3706404606665d2eb84a86825e24605dd4e5cca0320a753404b8b49b532"
  license "MIT"

  depends_on :macos
  depends_on xcode: ["15.0", :build]

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/dug"
    man1.install "dug.1"

    output = Utils.safe_popen_read(bin/"dug", "--generate-completion-script", "zsh")
    (zsh_completion/"_dug").write output
    output = Utils.safe_popen_read(bin/"dug", "--generate-completion-script", "bash")
    (bash_completion/"dug").write output
    output = Utils.safe_popen_read(bin/"dug", "--generate-completion-script", "fish")
    (fish_completion/"dug.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dug --version")
    assert_match "ANSWER SECTION", shell_output("#{bin}/dug example.com")
  end
end
