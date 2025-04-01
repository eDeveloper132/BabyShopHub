import { defineType, defineField } from 'sanity';

export default defineType({
  name: 'userProfile',
  title: 'User Profile',
  type: 'document',
  fields: [
    // 📧 Email Address (Required)
    defineField({
      name: 'email',
      title: 'Email Address',
      type: 'string',
      validation: (Rule) => Rule.required().email(),
    }),
    // 👤 Username (Optional)
    defineField({
      name: 'username',
      title: 'Username',
      type: 'string',
    }),
    // 🏠 Address (Optional)
    defineField({
      name: 'address',
      title: 'Address',
      type: 'text',
    }),
    // 📮 Postal Code (Optional)
    defineField({
      name: 'postalCode',
      title: 'Postal Code',
      type: 'string',
      validation: (Rule) =>
        Rule.min(4).max(10).regex(/^\d{4,10}$/, {
          name: 'postal code',
          invert: false,
        }),
    }),
    // 📞 Phone Number (Optional)
    defineField({
      name: 'phoneNumber',
      title: 'Phone Number',
      type: 'string',
      validation: (Rule) =>
        Rule.regex(/^\+?\d{7,15}$/, {
          name: 'phone number',
          invert: false,
        }),
    }),
    // 🎂 Date of Birth (Optional)
    defineField({
      name: 'dateOfBirth',
      title: 'Date of Birth',
      type: 'date',
    }),
    // 🖼️ Profile Image (Optional)
    defineField({
      name: 'profileImage',
      title: 'Profile Image',
      type: 'image',
      options: { hotspot: true },
    }),
    // 🛒 Past Orders (Optional Subfield)
    defineField({
      name: 'pastOrders',
      title: 'Past Orders',
      type: 'array',
      of: [
        {
          type: 'object',
          title: 'Order',
          fields: [
            defineField({
              name: 'orderId',
              title: 'Order ID',
              type: 'string',
              validation: (Rule) => Rule.required(),
            }),
            defineField({
              name: 'orderDate',
              title: 'Order Date',
              type: 'datetime',
              validation: (Rule) => Rule.required(),
            }),
            defineField({
              name: 'totalAmount',
              title: 'Total Amount',
              type: 'number',
              validation: (Rule) => Rule.required().min(0),
            }),
            defineField({
              name: 'status',
              title: 'Order Status',
              type: 'string',
              options: {
                list: [
                  { title: 'Pending', value: 'pending' },
                  { title: 'Completed', value: 'completed' },
                  { title: 'Cancelled', value: 'cancelled' },
                ],
                layout: 'radio',
              },
              validation: (Rule) => Rule.required(),
            }),
          ],
          preview: {
            select: {
              title: 'orderId',
              subtitle: 'status',
            },
          },
        },
      ],
    }),
  ],
});
