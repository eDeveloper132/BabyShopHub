import { client } from "@/sanity/lib/client";
import { groq } from "next-sanity";
import { All } from "../types/All";
import { UserProfile } from "../types/UserProfile";

export async function getInnerwears(): Promise<All[]> {
  // Directly return the promise from client.fetch
  return client.fetch(groq`*[_type == "innerwears"]`);
}

// 🟢 Fetch a single product by ID
export async function getInnerwearById(id: string): Promise<All | null> {
  return client.fetch(groq`*[_type == "innerwears" && _id == $id][0]`, { id });
}

export async function getOutfits(): Promise<All[]> {
  // Directly return the promise from client.fetch
  return client.fetch(groq`*[_type == "outfits"]`);
}

// 🟢 Fetch a single product by ID
export async function getOutfitById(id: string): Promise<All | null> {
  return client.fetch(groq`*[_type == "outfits" && _id == $id][0]`, { id });
}

export async function getToys(): Promise<All[]> {
  // Directly return the promise from client.fetch
  return client.fetch(groq`*[_type == "toys"]`);
}

// 🟢 Fetch a single product by ID
export async function getToyById(id: string): Promise<All | null> {
  return client.fetch(groq`*[_type == "toys" && _id == $id][0]`, { id });
}

export async function getWatches(): Promise<All[]> {
  // Directly return the promise from client.fetch
  return client.fetch(groq`*[_type == "watches"]`);
}

// 🟢 Fetch a single product by ID
export async function getWatchById(id: string): Promise<All | null> {
  return client.fetch(groq`*[_type == "watches" && _id == $id][0]`, { id });
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