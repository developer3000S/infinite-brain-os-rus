---
# Claude Code command keys
# (no special primitives beyond the file location)

# Infinite Brain keys
id: command-create-namespace
aliases: ["command-create-namespace", "create-namespace"]
type: command
namespace: canon-system-ontology
summary: "Slash command that creates a new namespace file under _system/namespaces/ in the personal repo, with lifecycle_state: scratch."
auto_inject: false
applicable_when: "Use when an operator wants to introduce a new namespace for an active research session, project area, or governance bucket that does not fit any existing namespace."
confidence: 0.9
verified_at: 2026-05-20
verified_by: ai-architect
staleness_signal: "Review if the namespace file schema or directory structure in _system/namespace-index-schema.md or _system/namespaces/ changes."
lifecycle_state: canon
owner_type: company
visibility: workspace
export_class: internal
retrieval_class: normal
tags: [command, namespace, scaffolding, governance]
edges:
  - target: rule-voice-and-style
    type: implements
    weight: 1.0
    note: "Generated namespace file follows the no-em-dash and frontmatter-before-body rules."
  - target: agent-brain-curator
    type: feeds
    weight: 0.8
    note: "Scratch-lifecycle namespaces created by this command are surfaced by the curator for promotion or merge."
related: []
source_url: null
local_path: entities/commands/create-namespace.md
---

# /create-namespace

Создаёт новый файл пространства имён в `_system/namespaces/` с `lifecycle_state: scratch`.
Используется в личных репозиториях, чтобы ввести специальное пространство имён для
исследовательской сессии, проектной области или управленческой категории.

## Когда это использовать

- Начало новой исследовательской сессии, которая не подходит под `research-general` или
  любое другое существующее пространство имён.
- Запуск проектного пространства имён, которому нужны собственные управленческие настройки.
- Выделение тематического пространства имён внутри личного репозитория для будущего
  рассмотрения продвижения.

## Когда это НЕ использовать

- Потребность подходит под существующее каноническое пространство имён. Используйте его.
- Вы находитесь в репозитории департамента или корпоративного канона. Откройте pull
  request, который добавляет файл пространства имён напрямую; не создавайте scratch
  пространства в канон-репозиториях.
- Потребность в теге темы, канале источника или различии авторов. Используйте поля
  frontmatter (`tags`, `source_channel`, `source_author`) на затрагиваемых узлах вместо этого.
- Вы хотите построить настоящее пространство имён из существующего корпуса или папки
  источников. Используйте `/build-knowledge-base`, который проходит через механизм
  профиля V2, канона, синтеза, поддержки и валидации.

## Как это работает

Команда запрашивает у оператора четыре входа:

1. **Имя пространства имён (slug)**: kebab-case, например, `research-llm-agents-2026`,
   `project-launch-q4`, `competitor-acme`.
2. **Назначение**: однострочное утверждение того, что покрывает это пространство имён.
3. **Группа**: одна из `operations`, `research`, `product`, `competitive-intel`,
   `personal` или новая группа, документированная в ответе.
4. **Владелец**: хэндл оператора (по умолчанию владелец личного репозитория).

Затем команда:

1. Проверяет, что slug ещё не существует в `_system/namespaces/` (проверка коллизий).
2. Записывает `_system/namespaces/{slug}.md` с требуемым frontmatter и телом-заглушкой.
3. Добавляет строку в `_system/namespaces/INDEX.md` в таблицу каталога и в
   соответствующую секцию по группам.
4. Сообщает о созданных или изменённых путях файлов и напоминает оператору запустить
   `bash _system/validate.sh`, если validate.sh установлен в этом личном репозитории.

## Шаблон тела

Сгенерированный файл пространства имён использует этот шаблон тела:

```markdown
---
id: namespace-{slug}
name: {slug}
purpose: "{purpose}"
owner: {owner}
lifecycle_state: scratch
created: {today}
group: {group}
retrieval_class: explicit
export_class: internal
default_visibility: private
tags: [namespace, scratch]
supersedes: null
notes: "Created via /create-namespace. Promote to candidate when the namespace stabilizes."
---

# {slug}

## Summary

{purpose}

## Defaults

| Field | Default |
|-------|---------|
| `lifecycle_state` on nodes | `scratch` or `research` |
| `retrieval_class` on nodes | `explicit` |
| `export_class` on nodes | `internal` |

## Use for

(operator fills in)

## Do not use for

(operator fills in)

## Promotion path

When this namespace stabilizes, promote it from scratch to candidate by opening a pull request against the appropriate department or company-canon repo. The brain-curator agent surfaces aged scratch namespaces for review.

## Notes

Created by /create-namespace on {today}.
```

## Крайние случаи

- **Коллизия с существующим пространством имён**: команда отказывается перезаписывать и
  запрашивает другой slug.
- **Slug содержит заглавные буквы или пробелы**: команда приводит к нижнему регистру и
  слагифицирует перед проверкой.
- **Группы нет в списке по умолчанию**: команда принимает любую непустую строку и
  предлагает оператору добавить секцию по группам в INDEX.md, если группа в этом
  репозитории совсем новая.
- **`_system/namespaces/` не существует**: команда создаёт его вместе со свежим INDEX.md,
  используя формат INDEX.md из canon-шаблона как затравку.
- **INDEX.md не существует**: команда создаёт его со свежим каталогом и записью для
  нового пространства имён.

## Доказательства

Выведено из секции схемы пространств имён спецификации v3 апстрима (PROVENANCE.yml
фиксирует происхождение источника). Жизненный цикл scratch в личном репозитории для
специальных пространств имён это точка входа для создания пространств имён; продвижение
в канон: отдельный поток pull request'ов.

## Рёбра

`feeds: agent-brain-curator`, потому что созданные здесь scratch-пространства: ровно то,
что агент-куратор выносит на рассмотрение продвижения или слияния.

`implements: rule-voice-and-style`, потому что тело сгенерированного файла пространства
имён соблюдает правило без тире em и правило «frontmatter перед телом».

## Примечания

Команда намеренно минимальна: она не генерирует содержимое тела, кроме заглушки.
Ожидается, что операторы вручную заполнят секции «использовать/не использовать», чтобы
политика пространства имён отражала их реальное намерение.
