export interface Brew {
  id: string
  userName: string
  placeName: string | null
  placeNeighborhood?: string
  rating: number
  coffeeType: string
  tastingNotes: string[]
  caption: string
}

export const mockBrews: Brew[] = [
  {
    id: '1',
    userName: 'Alex',
    placeName: 'Sightglass Coffee',
    placeNeighborhood: 'Mission',
    rating: 4.5,
    coffeeType: 'Latte',
    tastingNotes: ['Chocolate', 'Nutty', 'Smooth'],
    caption: 'Perfect morning ritual. Single-origin Ethiopian.',
  },
  {
    id: '2',
    userName: 'Alex',
    placeName: 'Ritual Coffee Roasters',
    placeNeighborhood: 'Mission',
    rating: 4.8,
    coffeeType: 'Flat White',
    tastingNotes: ['Floral', 'Citrus', 'Bright'],
    caption: 'Killer flat white. Vibes immaculate.',
  },
  {
    id: '3',
    userName: 'Alex',
    placeName: null,
    rating: 5,
    coffeeType: 'Pour Over',
    tastingNotes: ['Berry', 'Bright'],
    caption: 'Homemade Yirgacheffe. Worth the wait.',
  },
]

export const mockPlaces = [
  { id: '1', name: 'Sightglass Coffee', neighborhood: 'Mission', city: 'San Francisco' },
  { id: '2', name: 'Ritual Coffee Roasters', neighborhood: 'Mission', city: 'San Francisco' },
  { id: '3', name: 'Blue Bottle Coffee', neighborhood: 'SOMA', city: 'San Francisco' },
  { id: '4', name: 'Four Barrel Coffee', neighborhood: 'Mission', city: 'San Francisco' },
]

export const coffeeTypes = [
  'Espresso', 'Ristretto', 'Lungo', 'Doppio', 'Americano',
  'Latte', 'Cappuccino', 'Flat White', 'Cortado', 'Macchiato',
  'Mocha', 'White Mocha', 'Affogato', 'Vienna Coffee',
  'Cold Brew', 'Frappuccino',
]

export const tastingNotes = [
  'Chocolate', 'Caramel', 'Nutty', 'Citrus', 'Floral',
  'Berry', 'Smooth', 'Bright', 'Earthy', 'Sweet',
]
