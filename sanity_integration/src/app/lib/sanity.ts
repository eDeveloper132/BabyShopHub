import { client } from "@/sanity/lib/client";
import { groq } from "next-sanity";

// Define a TypeScript type for a Product
export type Product = {
  _id?: string; // Optional Sanity document ID
  title: string;
  video: { asset: { _ref: string } }; // Reference to a Sanity file
  images: { asset: { _ref: string } }[]; // Array of image references
  description: string;
  price: number;
};
export type UserProfile = {
  _id?: string; // Optional Sanity document ID
  email: string;
  username?: string;
  address?: string;
  postalCode?: string;
  phoneNumber?: string;
  dateOfBirth?: string;
  profileImage?: { asset: { _ref: string } };
  pastOrders?: {
    orderId: string;
    orderDate: string;
    totalAmount: number;
    status: "pending" | "completed" | "cancelled";
  }[];
};
// 🟢 Fetch all products
export async function getProducts(): Promise<Product[]> {
  // Directly return the promise from client.fetch
  return client.fetch(groq`*[_type == "product"]`);
}

// 🟢 Fetch a single product by ID
export async function getProductById(id: string): Promise<Product | null> {
  return client.fetch(groq`*[_type == "product" && _id == $id][0]`, { id });
}

// 🟢 Create a new product
export async function createProduct(data: Product): Promise<Product> {
  return client.create({
    _type: "product",
    ...data,
  });
}

// 🟢 Update a product by ID
export async function updateProduct(id: string, data: Partial<Product>): Promise<Product> {
  return client.patch(id).set(data).commit();
}

// 🟢 Delete a product by ID
export async function deleteProduct(id: string): Promise<Product> {
  return client.delete(id);
}
export async function getProfile(email: string): Promise<UserProfile | null> {
  return client.fetch(
    groq`*[_type == "userProfile" && email == $email][0]`,
    { email }
  );
}

// 🟢 Create a new user profile
export async function createProfile(data: UserProfile): Promise<UserProfile> {
  return client.create({
    _type: "userProfile",
    ...data,
  });
}

// 🟢 Update a user profile by ID
export async function updateProfile(id: string, data: Partial<UserProfile>): Promise<UserProfile> {
  return client.patch(id).set(data).commit();
}

// 🟢 Delete a user profile by ID
export async function deleteProfile(id: string): Promise<UserProfile> {
  return client.delete(id);
}