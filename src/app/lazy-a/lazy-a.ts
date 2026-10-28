import { Component } from '@angular/core';
import { label } from '../shared/label';

@Component({ selector: 'app-lazy-a', template: '<p>lazy-a works {{ text }}</p>' })
export class LazyA {
  protected text = label({ value: 'a' });
}
