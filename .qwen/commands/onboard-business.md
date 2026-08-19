---
id: "cmd-onboard-business"
aliases: ["cmd-onboard-business", "onboard-business"]
type: "Command"
namespace: "ai-architecture"
lifecycle_state: "research"
summary: "Entry-point command for the business onboarding engine: interview the person, recommend architecture, and scope accepted recommendations into launchable projects and sprints."
confidence: 0.8
retrieval_class: "identity"
export_class: "public"
description: "Use when a person wants the brain to learn their business and tell them what to build: runs the full interview, recommendation, and scoping loop. Also usable mid-life to diff an evolved business against the existing architecture."
edges:
  - target: "[[skill-interview-business]]"
    relation: "delegates_to"
    confidence: 0.95
  - target: "[[skill-recommend-architecture]]"
    relation: "delegates_to"
    confidence: 0.95
  - target: "[[workflow-onboard-business-architecture]]"
    relation: "uses"
    confidence: 0.95
created: "2026-06-10"
---

# /onboard-business

Сядьте с мозгом и дайте ему изучить ваш бизнес, затем пусть он скажет вам, что строить.
Одна команда запускает всю входную дверь:

```text
/onboard-business
```

Опционально с контекстом:

```text
/onboard-business Мы ведём небольшую студию свечей, в основном опт плюс веб-магазин.
Мне нужна помощь понять, с чего начать.
```

Эта команда должна:

1. проверить наличие существующей карты бизнеса под `intake/processed/` и существующей
   описи архитектуры, и выбрать режим:
   - **первый запуск**: карты нет; провести полное интервью
   - **повторный запуск**: карта есть; подтвердить, что всё ещё действует, провести
     интервью только по изменениям и сверить рекомендации с архитектурой, которая уже
     существует
2. провести интервью по [[skill-interview-business]]: простой язык, один вопрос за раз,
   повторы фаз, карта бизнеса записывается в
   `intake/processed/<date>-business-map.md`
3. сформировать ограниченный набор рекомендаций по [[skill-recommend-architecture]]:
   максимум один департамент, три пространства имён, три рабочих процесса, с отложенным
   списком Later и непустым списком «не строить пока», каждый пункт цитирует собственные
   слова человека; если интервью выявило реальный сигнал, набор может завершиться
   опциональной заметкой об инструментах (Obsidian, n8n, Paperclip) со ссылкой на
   `docs/local-tooling-setup.md`, вне потолка и никогда не навязываемой
4. представить набор и дать человеку принять подмножество; ничего не скоупится без
   явного принятия
5. передать принятое подмножество в [[workflow-onboard-business-architecture]], который
   создаёт один проект на каждый принятый пункт и генерирует для каждого запускаемую
   папку спринта сварма, затем объясняет человеку, как именно запустить каждый спринт
   в новом терминале
6. оставить запись запуска в `outputs/`

Команда намеренно тонкая: метод интервью живёт в навыке, суждение живёт в навыке,
скоупинг живёт в рабочем процессе. Этот файл только связывает их.
