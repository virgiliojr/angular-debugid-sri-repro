import { Component } from '@angular/core';
import { label } from '../shared/label';

@Component({ selector: 'app-lazy-b', template: '<p>lazy-b works {{ text }}</p>' })
export class LazyB {
  protected text = label({ value: 'b' });
}
