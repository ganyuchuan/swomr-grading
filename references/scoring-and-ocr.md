# 评分映射与 OCR 辅助

## 把评分标准转换成集合

评分前先写成：

```text
point_1 = [关键词, 同义表达]
point_2 = [关键词, 同义表达]
point_3 = [关键词, 同义表达]
score = 命中的不同 point 数
```

不要写成“出现几个关键词就给几分”。同一得分点的多个备选词只取一次。

## 关键词判定

优先看语义，不要求字形完全一致：

- 修饰词缺失但核心词清楚：可给分。
- 明显形近字且所在语境唯一：可给分。
- 单字残片无法确定完整关键词：放大复核。
- 同义但明确指向正确答案：可给分。
- 与其他景物混淆或明确答错：不给分。

评分前逐项记录：

```text
第 1 点：命中 / 未命中 / 待复核
第 2 点：命中 / 未命中 / 待复核
第 3 点：命中 / 未命中 / 待复核
```

## 常见 OCR 问题

- 手写连笔使“桃林”识别为“挑林”“枇林”等。
- “石磨”可能被识别为“石麼”“石魔”“石鹿”“右磨”。
- “断碑”可能被识别为“断碎”“断邳”。
- “旧阶石”可能被识别为“旧所石”“旧防石”“旧日石”。
- 两个相邻答案可能被合并为一行，一个答案也可能被拆到两个名称行。

这些只是候选模式，不是自动正确判据。至少满足以下之一才给对应得分点：

- 完整核心词可辨认；
- 多个 OCR 候选均指向同一词；
- 放大图后结合原文语境能合理确认。

## 安全的批处理伪代码

```text
for each current paper:
    state = read current accessibility state
    ensure current paper is unreviewed
    screenshot = capture current view
    text = local_ocr(screenshot)
    ensure question number is visible in text
    points = match_distinct_rubric_points(text)
    if ambiguous:
        open large image and inspect
    submit points once
    wait for page update
    verify review_count increased OR exam_id changed
    append audit log
```

任何验证失败都必须停止当前批次并人工检查。

## 校准

首次使用新的评分标准时先处理约 10 份，并请有评分权限的人回评。重点关注：

- 漏给近义词；
- 同一得分点重复计分；
- OCR 把无关内容误判为关键词；
- 只写半个关键词时的边界。

校准后记录差异原因，再扩大批量。不能把 10 份样本的一致性视为全部试卷准确。

## 审计日志

至少记录：

```json
{
  "examId": "保密号",
  "before": 100,
  "score": 2,
  "after": 101,
  "text": "OCR 文本及候选"
}
```

日志用于发现跳卷、重复提交和 OCR 异常，不包含学生姓名等不必要信息。
