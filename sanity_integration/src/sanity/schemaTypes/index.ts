import { type SchemaTypeDefinition } from 'sanity'
import shoesSchema from '../shoes'
import profileSchema from '../profile'
import innerwearsSchema from '../innerwears'
import outfitsSchema from '../outfits'
import toysSchema from '../toys'
import watchesSchema from '../watches'
export const schema: { types: SchemaTypeDefinition[] } = {
  types: [shoesSchema, innerwearsSchema, outfitsSchema, toysSchema, watchesSchema, profileSchema],
}
