---
id: "rule-studio-brand-voice"
aliases: ["rule-studio-brand-voice", "studio-brand-voice"]
type: "Rule"
namespace: "emberline-studio"
lifecycle_state: "research"
summary: "Emberline's brand voice rule: warm but plain, sensory specifics over adjectives, honest materials, plain prices."
confidence: 0.9
retrieval_class: "identity"
export_class: "public"
name: "studio-brand-voice"
description: "Behavioral constraint: every customer-facing word from Emberline Candle Studio, listings, emails, and collection pages, follows this voice."
edges:
  - target: "[[knowledge-emberline-studio-brand-essentials]]"
    relation: "derived_from"
    confidence: 0.85
created: "2026-06-11"
---

# Правило: голос бренда студии

Применяется к каждому слову, обращённому к клиенту: карточки товаров, ответы на письма,
страницы коллекций и тексты на упаковке. Агенты, работающие с черновиками в этом
пространстве имён, загружают это правило первым.

## Голос

- **Тепло, но просто.** Пишите как мастер, говорящий через верстак, а не как люксовый
  бренд, вещающий с билборда.
- **Конкретные сенсорные детали вместо прилагательных.** Называйте то, что находит нос.
  «Кедр и гвоздика» всегда лучше «богатый и манящий».
- **Честные материалы.** Называйте воск, фитиль и источник аромата как есть. Если свеча
  использует синтетическое ароматическое масло, говорите об этом.
- **Простые цены и наличие.** Называйте цену числом, а наличие фактом. «Снова в наличии
  3 марта» лучше, чем «скоро вернёмся».

## Никаких ароматных клише

Эти слова запрещены в текстах об ароматах: luxurious, indulgent, intoxicating, heavenly,
divine, signature blend, premium, evocative.

## Что делать

- Начинайте с самой сильной ноты аромата: «Сначала копчёный кедр, затем каштан».
- Называйте числа просто: «Горит около 45 часов. 28 долларов».
- Честно признавайте ограничения: «В этой партии 40 свечей; когда распродастся, её больше
  не будет».

## Чего не делать

- Не нанизывайте прилагательные: «тёплое, богатое, уютное, манящее сияние».
- Не прячьте материалы за расплывчатостью: «наша фирменная люксовая смесь воска».
- Не уклоняйтесь от наличия: «распродаётся!» без даты или количества.

## Источник

Выведено из `[[knowledge-emberline-studio-brand-essentials]]`. Когда основные положения
бренда меняются, пересмотрите это правило в той же сессии.
