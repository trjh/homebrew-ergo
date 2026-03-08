class Ergo < Formula
  desc "Modern IRC server written in Go"
  homepage "https://github.com/ergochat/ergo"
  version "2.17.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ergochat/ergo/releases/download/v#{version}/ergo-#{version}-macos-arm64.tar.gz"
      sha256 "70838978cbb4ce82c88365d17032a642f96cc9e1750010c6407b00ed10495209"
    else
      url "https://github.com/ergochat/ergo/releases/download/v#{version}/ergo-#{version}-macos-x86_64.tar.gz"
      sha256 "b159bcc8509497653683b9b9153deaa154cce6398b0874b972ee5f51084bfbd9"
    end
  end

  def install
    bin.install "ergo"

    if Dir.exist?("docs")
      pkgshare.install Dir["docs/**/*"]
    end

    if File.exist?("default.yaml")
      pkgshare.install "default.yaml"
      etc.install pkgshare/"default.yaml" => "ergo.yaml" unless (etc/"ergo.yaml").exist?
    end
  end

  service do
    run [opt_bin/"ergo", "run", "--conf", etc/"ergo.yaml"]
    keep_alive true
    working_dir var
    log_path var/"log/ergo.log"
    error_log_path var/"log/ergo.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ergo version")
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end
end
