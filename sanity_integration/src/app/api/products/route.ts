import { client } from "@/sanity/lib/client";
import { NextResponse } from "next/server";

// Fetch products from Sanity (ensure async)
export async function getProducts() {
    const data = await client.fetch('*[_type == "product"]');
    return data; // Returning resolved data
}

// API GET route
export async function GET() {
  const data = {
    message: "Hello from products storage!",
    items: await getProducts(), // Await the function to resolve
  };

  return NextResponse.json(data, { status: 200 });
}
