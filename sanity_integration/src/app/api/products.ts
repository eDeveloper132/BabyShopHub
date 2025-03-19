import { client } from "@/sanity/lib/client";
import { NextResponse } from 'next/server';

export function getProducts() {
    const Data = client.fetch('*[_type == "product"]');
    return Data
}

export async function GET() {
  const data = {
    message: "Hello from products storage!",
    items: await getProducts(),
  };

  return NextResponse.json(data, { status: 200 });
}