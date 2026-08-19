# Obsidian Dashboard

Основная поверхность просмотра, когда этот репозиторий открыт как хранилище Obsidian.

## Ориентация

- Начните здесь: [[START-HERE]]
- Контракт и карта папок: [[README]]
- Заметки о конфигурации хранилища: `.obsidian/README.md`
- Пошаговое руководство: `docs/getting-started.md`

## Основные пути просмотра

- Карточка доктрины: [[knowledge/ai-architecture/canon/doctrine-card|doctrine-card]]
- Примерное пространство имён: [[knowledge/emberline-studio/INDEX|emberline-studio]]
- Примерный проект: [[projects/_example/PLAN|example project PLAN]]
- Примерный департамент: [[departments/example-studio-ops/INDEX|example-studio-ops]]
- Ткань входящих данных: [[intake/README|intake]]

## Вид графа

Граф окрашен по `lifecycle_state` (конфиг поставляется в `.obsidian/graph.json`):
scratch, research, candidate, canon. Wikilinks и рёбра frontmatter это линии. Здоровый
мозг становится плотнее вокруг canon и держит scratch на краях.

## Привычки

- Новая мысль: захватите её в `intake/sources/` или прямо в пространство имён как scratch.
- Новый урок: `memory/`, с ребром к тому, что он информирует.
- Конец рабочей сессии: обзор закрытия сессии, затем проверьте граф на наличие сирот.
