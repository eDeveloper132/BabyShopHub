import { type SchemaTypeDefinition } from 'sanity'
import toysSchema from '../toys'
import watchesSchema from '../watches'
import UserProfile from '../profile'
import outfitsSchema from '../outfits'
import innerwearsSchema from '../innerwears'
// import shoesSchema from '../shoes'
export const schema: { types: SchemaTypeDefinition[] } = {
  types: [toysSchema,watchesSchema,outfitsSchema,innerwearsSchema,UserProfile],
}
