// All available plant icons
export type MediaKey =
  | 'seedling'
  | 'herb'
  | 'rose'
  | 'cactus'
  | 'blossom'
  | 'cherryblossom'
  | 'hibiscus'
  | 'hyacinth'
  | 'lotus'
  | 'pottedplant'
  | 'rosette'
  | 'sunflower'
  | 'tulip'
  | 'whiteflower'
  | 'palmtree'
  | 'deciduoustree'
  | 'evergreentree';

export const PLANT_ICON_KEYS: MediaKey[] = [
  'seedling',
  'herb',
  'rose',
  'cactus',
  'blossom',
  'cherryblossom',
  'hibiscus',
  'hyacinth',
  'lotus',
  'pottedplant',
  'rosette',
  'sunflower',
  'tulip',
  'whiteflower',
  'palmtree',
  'deciduoustree',
  'evergreentree'
];

export function mediaFromKey(key: MediaKey | string): ResourceStr {
  switch (key) {
    case 'herb':
      return $r('app.media.herb');
    case 'rose':
      return $r('app.media.rose');
    case 'cactus':
      return $r('app.media.cactus');
    case 'blossom':
      return $r('app.media.blossom');
    case 'cherryblossom':
      return $r('app.media.cherryblossom');
    case 'hibiscus':
      return $r('app.media.hibiscus');
    case 'hyacinth':
      return $r('app.media.hyacinth');
    case 'lotus':
      return $r('app.media.lotus');
    case 'pottedplant':
      return $r('app.media.pottedplant');
    case 'rosette':
      return $r('app.media.rosette');
    case 'sunflower':
      return $r('app.media.sunflower');
    case 'tulip':
      return $r('app.media.tulip');
    case 'whiteflower':
      return $r('app.media.whiteflower');
    case 'palmtree':
      return $r('app.media.palmtree');
    case 'deciduoustree':
      return $r('app.media.deciduoustree');
    case 'evergreentree':
      return $r('app.media.evergreentree');
    case 'seedling':
    default:
      return $r('app.media.seedling');
  }
}
