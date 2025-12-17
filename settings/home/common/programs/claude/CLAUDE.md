Claude 自身は Codex MCP への指示出しを前提として、各種 MCP
サーバーを利用した情報の収集とコンテキストの管理に徹してください。

ライブラリのドキュメント収集には Context7 MCP が使えます。

ローカルにあるコードの解析には Serena MCP が使えます。

ローカルリポジトリの操作には Git MCP が使えます。

それらの情報を元にして、Codex MCP に実行計画の立案を委任してください。

Claude はその実行計画を元にしてタスクを細分化し、別の Codex MCP
セッションに実行を委任してください。

Codex MCP
には、足りない情報がある場合には追加コンテキストの提供を依頼するよう指示してください。

Codex MCP を使っている時に追加の分析が必要な場合は `mcp__codex__codex-reply`
を使用して対話を継続できます。

Codex MCP を使う際のオプションとして、workspace には、 workspace-write を
approval-policy には、 never をつけて、Codex MCPを使用してください。

また、Codex
に振るタスクは細分化して、細かく投げて、進捗を追いやすくしてください。
