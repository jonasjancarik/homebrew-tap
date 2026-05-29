class CodexAutofocus < Formula
  desc "Bring the Codex desktop app to the front when a Codex turn finishes"
  homepage "https://github.com/jonasjancarik/codex-autofocus"
  url "https://github.com/jonasjancarik/codex-autofocus/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "7851e8f4df4cbe8bcd6e2e8b001c58756dea733ba715c6c27793c6e48fadd3fe"
  license :cannot_represent

  depends_on xcode: ["15.0", :build]

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release", "--product", "codex-autofocus"
    system "swift", "build", "--disable-sandbox", "--configuration", "release", "--product", "CodexAutofocusMenuBar"
    cli_binary = built_product("codex-autofocus")
    menu_binary = built_product("CodexAutofocusMenuBar")

    app = prefix/"Codex Autofocus.app"
    (app/"Contents/MacOS").mkpath
    (app/"Contents/Resources").mkpath
    cp menu_binary, app/"Contents/MacOS/CodexAutofocusMenuBar"
    cp cli_binary, app/"Contents/Resources/codex-autofocus"
    chmod 0755, app/"Contents/MacOS/CodexAutofocusMenuBar"
    chmod 0755, app/"Contents/Resources/codex-autofocus"

    (app/"Contents/Info.plist").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleExecutable</key>
        <string>CodexAutofocusMenuBar</string>
        <key>CFBundleIdentifier</key>
        <string>com.jonasjancarik.codex-autofocus</string>
        <key>CFBundleName</key>
        <string>Codex Autofocus</string>
        <key>CFBundlePackageType</key>
        <string>APPL</string>
        <key>LSMinimumSystemVersion</key>
        <string>13.0</string>
        <key>LSUIElement</key>
        <true/>
        <key>NSPrincipalClass</key>
        <string>NSApplication</string>
      </dict>
      </plist>
    XML

    bin.install cli_binary

    (bin/"codex-autofocus-menu").write <<~EOS
      #!/bin/bash
      exec /usr/bin/open -n "#{opt_prefix}/Codex Autofocus.app"
    EOS
  end

  def built_product(name)
    candidates = Pathname.glob(buildpath/".build/**/release/#{name}").select(&:file?)
    odie "SwiftPM did not build #{name}" if candidates.empty?
    candidates.first
  end

  def caveats
    <<~EOS
      To register the Codex hook, run:
        codex-autofocus install --binary "#{opt_bin}/codex-autofocus"

      Codex may ask you to review and trust the hook before it runs.

      To start the menu bar app, run:
        codex-autofocus-menu
    EOS
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/codex-autofocus --help")
    assert_path_exists prefix/"Codex Autofocus.app/Contents/MacOS/CodexAutofocusMenuBar"
    assert_path_exists prefix/"Codex Autofocus.app/Contents/Resources/codex-autofocus"
  end
end
