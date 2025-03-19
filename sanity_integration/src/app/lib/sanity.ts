// lib/sanity.ts
import { client } from "@/sanity/lib/client";

export async function getProducts() {
    return await client.fetch('*[_type == "product"]');
}
