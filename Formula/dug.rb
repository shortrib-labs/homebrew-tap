class Dug < Formula
  desc "macOS-native DNS lookup utility using the system resolver"
  homepage "https://github.com/shortrib-labs/dug"
  url "https://github.com/shortrib-labs/dug/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "b92d9d81c6a52234ab2fbe11fb412e773203a908db0e31f112f2789e37161883"
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
