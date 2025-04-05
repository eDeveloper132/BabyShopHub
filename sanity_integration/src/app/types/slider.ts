export type ImageGallery = {
    _id: string;
    _type: 'imageGallery';
    images: GalleryImage[];
  };
  
  export type GalleryImage = {
    _key: string;
    _type: 'image';
    asset: {
      _ref: string;
      _type: 'reference';
    };
    alt?: string;
  };
  