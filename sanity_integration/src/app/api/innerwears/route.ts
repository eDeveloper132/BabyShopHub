import { NextResponse } from "next/server";
import { getInnerwears, getInnerwearById } from "../../lib/sanity";

// ✅ CORS Headers (For Reusability)
const corsHeaders = {
  "Content-Type": "application/json",
  "Access-Control-Allow-Origin": "*", // Allow all origins (Restrict in production)
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type",
};

// 🟢 Handle GET request (Fetch all products)
export async function GET(req: Request) {
  try {
    const { searchParams } = new URL(req.url);
    const id = searchParams.get("id");

    if (id) {
      const product = await getInnerwearById(id);
      if (!product) {
        return NextResponse.json({ error: "Innerwear not found" }, { status: 404, headers: corsHeaders });
      }
      return NextResponse.json(product, { status: 200, headers: corsHeaders });
    } else {
      const products = await getInnerwears();
      return NextResponse.json(products, { status: 200, headers: corsHeaders });
    }
  } catch (error) {
    console.error("Error fetching Innerwears:", error);
    return NextResponse.json({ error: "Failed to fetch Innerwears" }, { status: 500, headers: corsHeaders });
  }
}

// ✅ Handle OPTIONS Request (CORS Preflight)
export function OPTIONS() {
  return NextResponse.json(null, { status: 204, headers: corsHeaders });
}
