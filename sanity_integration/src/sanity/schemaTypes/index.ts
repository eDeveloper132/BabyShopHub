import { type SchemaTypeDefinition } from 'sanity'
import bootsSchema from '../shoes'
import toysSchema from '../toys'
import watchesSchema from '../watches'
import UserProfile from '../profile'
import outfitsSchema from '../outfits'
// import shoesSchema from '../shoes'
export const schema: { types: SchemaTypeDefinition[] } = {
  types: [bootsSchema,toysSchema,watchesSchema,outfitsSchema,UserProfile],
}
