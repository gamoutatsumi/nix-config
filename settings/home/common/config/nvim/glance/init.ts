// @ts-types="npm:@types/markdown-it-emoji@3.0.1"
import { full as emoji } from "npm:markdown-it-emoji@3.0.0/";
// @ts-types="npm:@types/markdown-it@14.1.2"
import MarkdownIt from "npm:markdown-it@14.1.0";

export function createMarkdownRenderer(md: MarkdownIt): MarkdownIt {
  return md.use(emoji);
}
