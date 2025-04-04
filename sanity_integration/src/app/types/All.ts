export type All = {
    _id?: string; // Optional Sanity document ID
    title: string;
    video: { asset: { _ref: string } }; // Reference to a Sanity file
    images: { asset: { _ref: string } }[]; // Array of image references
    description: string;
    price: number;
  };