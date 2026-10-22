class Lovelace < Formula
  desc "Local-first work orchestrator for coding agents, Jira and GitHub"
  homepage "https://github.com/lovelacerun/lovelace"
  url "https://github.com/lovelacerun/lovelace/releases/download/v0.1.0/lovelace-0.1.0.tar.gz"
  sha256 "a73f61267b54871ad0f497c30b7246b61b0c089d21421e3d797f54de2b92e1f9"
  license "MIT"

  depends_on "herdr"
  depends_on :macos
  depends_on "node@24"

  def install
    libexec.install Dir["*"]
    # The stable opt path keeps the background server and agent callbacks working across upgrades.
    (bin/"lovelace").write <<~SH
      #!/bin/bash
      export LOVELACE_EXECUTABLE="#{opt_bin}/lovelace"
      exec "#{formula_opt_bin("node@24")}/node" "#{opt_libexec}/dist/index.js" "$@"
    SH
  end

  def caveats
    <<~EOS
      Set up Lovelace and start its server:
        lovelace init
    EOS
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lovelace version").strip
    assert_match "lovelace <command>", shell_output("#{bin}/lovelace help")
  end
end
