実際の実装に差し掛かる際には、Codex MCP を使用してください。
オプションとして、workspace には、 workspace-write を approval-policy には、
never をつけて、Codex MCPを使用してください。 また、Codex
に振るタスクは細分化して、細かく投げて、進捗を追いやすくしてください。

Codex には Context7、Serena、Sequential-Thinking などの MCP
サーバーが設定されています。タスクの特性に合わせてこれらのツールを使うよう Codex
に指示してください。

Serena
はローカルのコードを分析する際に役立ちます。一番汎用的なものなので、コードを参照する場合には基本的に有効化します。
Context7 はライブラリなどのドキュメントを参照するのに役立ちます。
Sequential-Thinking
は深い検討を行う場合に便利です。何度か検討を繰り返しても適切な結論が出ない場合に使ってください。

Codex を使っている時に追加の分析が必要な場合は `mcp__codex__codex-reply`
を使用して対話を継続できます。
