import { defineType, defineField } from 'sanity';
import { client } from './lib/client';

const toysSchema = defineType({
  name: 'toys',
  title: 'Toys',
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
          const existingShoes = await client.fetch(
            `*[_type == "toys" && title == $title && _id != $id][0]`,
            { title, id: document?._id }
          );

          return existingShoes ? 'Title must be unique' : true;
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
      validation: (Rule) => Rule.max(3).required(),
    }),
    defineField({
      name: 'description',
      title: 'Description',
      type: 'text',
      validation: (Rule) => Rule.required().min(10),
    }),
    defineField({
      name: 'price',
      title: 'Price',
      type: 'number',
      validation: (Rule) => Rule.required().min(0),
    }),
  ],
});

export default toysSchema;
