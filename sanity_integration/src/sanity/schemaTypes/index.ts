import { type SchemaTypeDefinition } from 'sanity'
import productSchema from '../product'
import profileSchema from '../profile'
export const schema: { types: SchemaTypeDefinition[] } = {
  types: [productSchema, profileSchema],
}
