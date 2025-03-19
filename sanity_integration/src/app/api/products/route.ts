import { NextResponse } from "next/server";
import { getProducts } from "@/app/lib/sanity"; // Import from the helper file

export async function GET() {
  const products = await getProducts();

  return new NextResponse(JSON.stringify(products), {
    status: 200,
    headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*", // Allow all origins
      "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
      "Access-Control-Allow-Headers": "Content-Type",
    },
  });
}
