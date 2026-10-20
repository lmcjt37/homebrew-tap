cask "baton" do
  version "1.1.0"
  sha256 "115d98c1d08e8b91e2ae9f5dfddf27127113d47678165b9a0fcede1637912b57"

  url "https://github.com/lmcjt37/baton-releases/releases/download/v#{version}/Baton-#{version}-universal.dmg"
  name "Baton"
  desc "Run Maestro E2E flows for React Native apps across git worktrees"
  homepage "https://lmcjt37.github.io/baton-releases/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :monterey

  app "Baton.app"
  binary "#{appdir}/Baton.app/Contents/Resources/bin/baton"

  uninstall quit:   "dev.lmcjt37.baton",
            script: {
              executable:   "#{appdir}/Baton.app/Contents/Resources/bin/baton",
              args:         ["stop", "--force"],
              must_succeed: false,
            }

  zap script: {
        executable:   "/bin/sh",
        args:         [
          "-c",
          'f="$HOME/.baton/state.json"; [ -f "$f" ] || exit 0; ' \
          'tr -d " \n" < "$f" | sed -n "s/.*\"ownedSimulators\":\[\([^]]*\)\].*/\1/p" | ' \
          'tr -d "\"" | tr "," "\n" | ' \
          'while read -r udid || [ -n "$udid" ]; do ' \
          '[ -n "$udid" ] && xcrun simctl delete "$udid" < /dev/null; done; exit 0',
        ],
        must_succeed: false,
      },
      trash:  [
        "~/.baton",
        "~/Library/Application Support/Baton",
        "~/Library/Caches/dev.lmcjt37.baton",
        "~/Library/HTTPStorages/dev.lmcjt37.baton",
        "~/Library/Preferences/dev.lmcjt37.baton.plist",
        "~/Library/Saved Application State/dev.lmcjt37.baton.savedState",
      ]

  caveats <<~EOS
    Open Baton from Applications once before using `baton`: macOS asks
    before running an app downloaded from the internet.
  EOS
end
