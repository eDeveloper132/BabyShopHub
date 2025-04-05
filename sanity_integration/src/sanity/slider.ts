import { defineType, defineField } from 'sanity';

const sliderSchema = defineType({
  name: 'slider',
  title: 'Slider',
  type: 'document',
  fields: [
    defineField({
      name: 'images',
      title: 'Images',
      type: 'array',
      of: [
        {
          type: 'image',
          options: {
            hotspot: true, // Enables hotspot and crop functionality
          },
          fields: [
            {
              name: 'alt',
              title: 'Alt Text',
              type: 'string',
              description: 'Alternative text for accessibility',
            },
          ],
        },
      ],
      validation: (Rule) =>
        Rule.min(1).warning('At least one image is recommended'),
    }),
  ],
});

export default sliderSchema;
