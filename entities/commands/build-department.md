---
id: "cmd-build-department"
aliases: ["cmd-build-department", "build-department"]
type: "Command"
namespace: "ai-architecture"
lifecycle_state: "research"
summary: "Plain-English command that builds or upgrades a department assembly under departments/."
confidence: 0.9
retrieval_class: "identity"
export_class: "internal"
description: "Use when an operator wants to create or refine a department, its head agent, intake posture, linked tools and workflows, and its role in the AI shadow department model."
edges:
  - target: "[[skill-build-department]]"
    relation: "delegates_to"
    confidence: 0.96
  - target: "[[workflow-build-department]]"
    relation: "uses"
    confidence: 0.92
  - target: "[[skill-build-agent]]"
    relation: "delegates_to"
    confidence: 0.82
created: "2026-05-31"
---

# /build-department

Строит или модернизирует департамент на простом английском языке.

Пример:

```text
/build-department Build a shared devops-platform department that owns GitHub, CI/CD, secrets posture, deployment standards, and observability, then link domain departments to it rather than letting each own its own stack.
```

Эта команда должна:

1. прочитать запрос оператора на английском
2. определить функцию и тип департамента
3. создать или уточнить `departments/<slug>/INDEX.md`
4. создать недостающие сущности главного агента или рабочих процессов, когда это обосновано
5. добавить или связать нужные инструменты, пространства имён, передачи и позицию
   data-системы
6. оставить краткий отчёт о постройке в `outputs/`
