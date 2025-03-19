import { NextResponse } from "next/server";
import { getProducts } from "@/app/lib/sanity"; // Import from the helper file

export async function GET() {
  const products = await getProducts();

  return NextResponse.json({ 
    message: "Hello from products storage!", 
    items: products 
  });
}
