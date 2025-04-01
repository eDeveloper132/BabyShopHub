import { defineType, defineField } from 'sanity';
import { client } from './lib/client';
const productSchema = defineType({
  name: 'product',
  title: 'Product',
  type: 'document',
  fields: [
    defineField({
      name: 'title',
      title: 'Title',
      type: 'string',
      validation: (Rule) =>
        Rule.required().custom(async (title, context) => {
          if (!title) return 'Title is required';

          const { document } = context;

          // Query to check for duplicate titles
          const existingProducts = await client.fetch(
            `*[_type == "product" && title == $title && _id != $id][0]`,
            { title, id: document?._id }
          );

          return existingProducts ? 'Title must be unique' : true;
        }),
    }),
    defineField({
      name: 'video',
      title: 'Video',
      type: 'file',
      options: { accept: 'video/*' },
    }),
    defineField({
      name: 'images',
      title: 'Images',
      type: 'array',
      of: [{ type: 'image' }],
      validation: (Rule) => Rule.max(3).required(), // Uses ArrayRule implicitly
    }),
    defineField({
      name: 'description',
      title: 'Description',
      type: 'text',
      validation: (Rule) => Rule.required().min(10), // Uses StringRule implicitly
    }),
    defineField({
      name: 'price',
      title: 'Price',
      type: 'number',
      validation: (Rule) => Rule.required().min(0), // Uses NumberRule implicitly
    }),
  ],
});

export default productSchema;
