import { type SchemaTypeDefinition } from 'sanity'
import shoeSchema from '../Shoes'
import profileSchema from '../profile'
export const schema: { types: SchemaTypeDefinition[] } = {
  types: [shoeSchema, profileSchema],
}
