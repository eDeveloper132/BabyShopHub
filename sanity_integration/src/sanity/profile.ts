import { defineType, defineField } from 'sanity';

const profileSchema = defineType({
  name: 'userProfile',
  title: 'User Profile',
  type: 'document',
  fields: [
    // 🟢 Username
    defineField({
      name: 'username',
      title: 'Username',
      type: 'string',
      validation: (Rule) => Rule.required().min(3).max(30),
    }),

    // 🟢 Address
    defineField({
      name: 'address',
      title: 'Address',
      type: 'text',
      validation: (Rule) => Rule.required().min(10),
    }),

    // 🟢 Postal Code
    defineField({
      name: 'postalCode',
      title: 'Postal Code',
      type: 'string',
      validation: (Rule) =>
        Rule.required().min(4).max(10).regex(/^\d{4,10}$/, {
          name: 'postal code',
          invert: false,
        }),
    }),

    // 🟢 Phone Number
    defineField({
      name: 'phoneNumber',
      title: 'Phone Number',
      type: 'string',
      validation: (Rule) =>
        Rule.required().regex(/^\+?\d{7,15}$/, {
          name: 'phone number',
          invert: false,
        }),
    }),

    // 🟢 Date of Birth
    defineField({
      name: 'dateOfBirth',
      title: 'Date of Birth',
      type: 'date',
      validation: (Rule) => Rule.required(),
    }),

    // 🟢 Profile Image
    defineField({
      name: 'profileImage',
      title: 'Profile Image',
      type: 'image',
      options: { hotspot: true },
      validation: (Rule) => Rule.required(),
    }),
  ],
});
export default profileSchema;