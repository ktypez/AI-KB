---
type: skill
id: frontend-dev
last_updated: 2026-06-25
source: ~/.config/opencode/skills/frontend-dev/SKILL.md
category: engineering
projects: [global]
---

# frontend-dev Skill

**Purpose:** Expert frontend engineering — React 19, Next.js 15, Vue, Angular, Svelte, TypeScript, component architecture, state management, responsive design, performance optimization, testing, accessible UI/UX.

## Capabilities

### React & Next.js
- React 19: Actions, Server Components, async transitions, `useActionState`, `useOptimistic`, `useTransition`, `useDeferredValue`
- Next.js 15 App Router: Server vs Client Components, streaming, Suspense boundaries
- Server Actions for client-server data mutations
- Advanced routing: parallel routes, intercepting routes, route handlers, middleware
- Rendering: SSR, SSG, ISR, dynamic rendering, edge runtime
- Image optimization and Core Web Vitals
- Concurrent rendering and Suspense patterns
- Error boundaries and error handling

### Multi-Framework
- Vue 3: Composition API, reactivity, `<script setup>`, Pinia
- Angular: RxJS, DI, signals, standalone components
- Svelte: compile-time optimizations, runes, SvelteKit
- Nuxt: SSR/SSG, auto-imports, modules

### Component Architecture
- Atomic design principles, composition over inheritance
- Proper `key` usage, error boundaries, Suspense fallbacks
- Single-purpose components with clear TypeScript interfaces

### State Management & Data Fetching
- Local vs global state (Zustand, Jotai, Valtio, Pinia, Context, Redux Toolkit)
- TanStack Query, SWR, RTK Query with cache invalidation
- Offline functionality, optimistic updates, real-time (WebSockets, SSE)
- Loading, empty, error, edge-case states everywhere

### Styling & Design Systems
- Project's existing approach (Tailwind, CSS Modules, CSS-in-JS, vanilla-extract, styled-components)
- Mobile-first responsive with `clamp()`, container queries, Grid/Flexbox
- CSS custom properties for theming, design tokens, dark mode
- Accessible form controls, ARIA labels, touch targets ≥ 44px
- Animation (Framer Motion, React Spring, GSAP, Vue transitions)

### Performance & Optimization
- Lazy loading with dynamic imports
- `React.memo`, `useMemo`, `useCallback` judiciously
- Virtualize large lists (TanStack Virtual, react-window)
- Tree-shaking, bundle size < 200KB gzipped
- Core Web Vitals: FCP < 1.8s, TTI < 3.9s, CLS < 0.1, 60fps

### Testing & QA
- React/Vue Testing Library, Jest, Vitest
- Playwright, Cypress for E2E
- Storybook + Chromatic for visual regression
- axe-core for accessibility, Lighthouse CI

### Accessibility
- WCAG 2.1/2.2 AA compliance
- Keyboard navigation with visible `:focus-visible`
- ARIA where semantic HTML insufficient
- Color contrast 4.5:1 text, 3:1 large text
- Screen reader optimization

## Verification
- Dev server across mobile, tablet, desktop
- `npm run lint` + `npm run typecheck`
- Relevant tests
- Lighthouse audit (Performance, Accessibility, Best Practices, SEO)
- Tab through for keyboard navigation
- Bundle analysis if needed

(End of file - total 78 lines)