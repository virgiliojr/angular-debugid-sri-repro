export interface LabelInput {
  value: string;
}

export function label(input: LabelInput): string {
  return `label:${input.value}`;
}
