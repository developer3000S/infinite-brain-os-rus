---
id: "cmd-promote"
aliases: ["cmd-promote", "promote"]
type: "Command"
namespace: "personal-operator"
lifecycle_state: "research"
summary: "Command that prepares a personal node for promotion into canon repos."
confidence: 0.85
retrieval_class: "identity"
export_class: "internal"
description: "Promote a node from this personal repo to a department or company-canon repo. Rewrites frontmatter, resolves wikilinks, copies the file across repos, and opens a PR against the target repo."
edges:
  - target: "[[agent-brain-curator]]"
    relation: "produces_input_for"
    confidence: 0.6
created: "2026-05-20"
---

# /promote

Продвигает узел из этого личного репозитория в репозиторий департамента или
корпоративного канона. Команда переписывает frontmatter под соглашения целевого
репозитория, сканирует wikilink-ссылки на межрепозиторные ссылки, копирует файл в рабочую
ветку в клоне целевого репозитория и открывает pull request для рассмотрения гейтом
канонизации.

## Использование

```
/promote path/to/node.md target=department
/promote path/to/node.md target=company-canon
```

Первый аргумент: путь к файлу узла в этом репозитории (например,
`knowledge/personal-operator/playbooks/attribution-standard.md`). Аргумент `target`
называет, в какой канон-репозиторий продвигать.

## Что делает эта команда

1. Читает файл исходного узла и проверяет, что у него `lifecycle_state: research`. Любое
   другое состояние: отказ. `scratch` слишком рано. `candidate` и `canon` уже продвинуты.
   `archive` нужно сначала открыть заново.
2. Находит путь целевого репозитория. Соглашение: целевой репозиторий клонируется как
   соседняя директория рядом с этим личным репозиторием (например, `../acme-marketing/`
   для `target=department` или `../acme-company-canon/` для `target=company-canon`). Если
   соседа нет, команда завершается с понятным сообщением («склонируйте целевой
   репозиторий как соседа перед запуском /promote»).
3. Делегирует механику перемещения файла, перезаписи frontmatter и резолва wikilink-ов в
   `[[skill-cross-repo-move]]`.
4. Открывает pull request в целевом репозитории через `gh pr create`. Заголовок PR:
   `promote: {node-id}`. Тело PR: сводка того, что продвигается, id исходного узла,
   исходный репозиторий и чек-лист для ревьюера.

## Правила перезаписи frontmatter

Команда применяет к перемещённому файлу такие перезаписи:

| Поле | Значение источника | Значение цели |
|------|--------------------|---------------|
| `lifecycle_state` | `research` | `candidate` |
| `namespace` | `personal-operator` | зависит от цели: `canon-department` или `canon-company` |
| `local_path` | путь в личном репозитории | путь в целевом репозитории |

Для узлов, у которых уже есть более богатый frontmatter (`visibility`, `owner_type`,
`export_class`), команда сохраняет эти поля, но нормализует их под значения по умолчанию
целевого репозитория (например, `visibility: workspace`, `owner_type: team` для
департамента, `owner_type: company` для company-canon).

## Резолв wikilink-ов

Команда сканирует тело файла на встроенные `[[wikilink]]`-ссылки. Для каждой:

1. Если wikilink указывает на узел, который существует только в этом личном репозитории
   и не продвигается в этом PR, ссылка помечается в описании PR: «это продвижение
   ссылается на узел только личного репозитория; ревьюер должен решить, встроить ссылку,
   исключить зависимость или открыть отдельный promote для этого узла».
2. Если wikilink указывает на узел, который уже существует в целевом репозитории, ссылка
   сохраняется как есть.
3. Если wikilink указывает на узел в другом канон-репозитории (например, продвижение в
   департамент, а ссылка ведёт в company-canon), ссылка сохраняется. Межканонные ссылки
   допустимы.

## Шаблон описания PR

Команда генерирует описание PR по этому шаблону:

```markdown
## Promotion of {node-id}

**Source:** {source-repo}@{branch} `{source-path}`
**Target:** {target-repo} `{target-path}`
**Lifecycle:** research to candidate

### Body summary

{first paragraph of the node body}

### Wikilink notes

(any cross-repo or personal-only references the reviewer should know about)

### Canonization checklist

- [ ] Frontmatter complete and valid (run `bash _system/validate.sh` from the target repo root if available)
- [ ] Node-type is appropriate for the target repo's conventions
- [ ] Body content adheres to voice-and-style rule
- [ ] All wikilinks resolve in the target repo
- [ ] Reviewer accepts the promotion and merges, moving lifecycle to `canon`
```

## Крайние случаи

- **Целевой репозиторий не склонирован как сосед**: завершиться с понятным сообщением,
  перечисляющим ожидаемый путь и предлагаемую команду `git clone`.
- **У исходного узла `lifecycle_state` не `research`**: отказать с сообщением о требуемой
  предпосылке и правилах продвижения жизненного цикла.
- **У исходного узла отсутствуют обязательные поля frontmatter**: отказать и перечислить
  отсутствующие поля. Предложить запустить `bash _system/validate.sh`, если он установлен,
  или исправить вручную.
- **В целевом репозитории уже есть файл с тем же id**: отказать и предложить либо
  переименовать исходный узел, либо открыть UPDATE PR против существующего канонического
  файла.
- **Сеть или CLI `gh` недоступны**: выполнить копирование файла и перезапись frontmatter
  локально, затем выдать инструкции для открытия PR вручную.

## Примечания

- Эта команда не удаляет исходный файл из личного репозитория. Ревьюер или оператор может
  удалить его после слияния кандидата в канон или оставить как рабочую копию.
- Команда всегда работает в свежей git-ветке целевого репозитория (автоназвание
  `promote/{node-id}`), никогда против ветки по умолчанию.
