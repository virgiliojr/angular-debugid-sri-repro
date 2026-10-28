import { Routes } from '@angular/router';

export const routes: Routes = [
  { path: 'a', loadComponent: () => import('./lazy-a/lazy-a').then((m) => m.LazyA) },
  { path: 'b', loadComponent: () => import('./lazy-b/lazy-b').then((m) => m.LazyB) },
  { path: 'c', loadComponent: () => import('./lazy-c/lazy-c').then((m) => m.LazyC) },
];
