import { type SchemaTypeDefinition } from 'sanity'
import profileSchema from '../profile'
import innerwearsSchema from '../innerwears'
import outfitsSchema from '../outfits'
import toysSchema from '../toys'
import watchesSchema from '../watches'
// import shoesSchema from '../shoes'
export const schema: { types: SchemaTypeDefinition[] } = {
  types: [innerwearsSchema, outfitsSchema, toysSchema, watchesSchema, profileSchema],
}
