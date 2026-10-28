# swomr-grading

一份用于**云阅卷平台阅卷**的 SKILL，帮助 AI Agent 查看答题图片、按评分标准打分、批量处理试卷并减少误操作。

- **GitHub 仓库**：`ganyuchuan/swomr-grading`
- **适用 Agent**：Codex / ChatGPT Work / Claude Code / Cursor / GitHub Copilot / Gemini CLI / Windsurf Cascade / Cline / Roo Code / Continue / Aider / OpenHands / Devin / Amazon Q Developer / JetBrains AI Assistant / Replit Agent / Bolt.new / Lovable 等。

<img width="1206" height="905" alt="IMG_7732" src="https://github.com/user-attachments/assets/caeb18c5-6cbe-4624-8d27-905014f94bda" />
<img width="1206" height="904" alt="IMG_7730" src="https://github.com/user-attachments/assets/87a7ec3e-f79d-4846-a8df-744f24e3fccc" />
<img width="1206" height="904" alt="IMG_7731" src="https://github.com/user-attachments/assets/62a9d1c8-9daf-4da4-bc3e-b689c7b6a2a4" />

> Agent 需要能够读取 `SKILL.md`，并使用浏览器、截图或本地 OCR 能力。

## 使用前

1. 告诉你的 Agent 安装 `swomr-grading`。
2. 在[云阅卷平台](https://cloud.swomr.com/web/main.jsp)打开待评试卷。

## 使用方法

### A：使用 AI 的评分标准

```text
使用 `swomr-grading` SKILL 批阅当前/剩余试卷。
```

### B：使用你自己的评分标准

```text
使用 `swomr-grading/SKILL.md`，按以下评分标准批阅当前/剩余试卷：
[填写你的评分标准]
```
