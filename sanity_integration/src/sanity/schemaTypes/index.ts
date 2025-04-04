import { type SchemaTypeDefinition } from 'sanity'

import bootsSchema from '../Shoes'
import innerwearsSchema from '../Innerwears'
import outfitsSchema from '../Outfits'
import toysSchema from '../Toys'
import watchesSchema from '../Watches'
import UserProfile from '../Profile'

// import shoesSchema from '../shoes'
export const schema: { types: SchemaTypeDefinition[] } = {
  types: [innerwearsSchema, outfitsSchema, toysSchema, watchesSchema, bootsSchema, UserProfile],
}
