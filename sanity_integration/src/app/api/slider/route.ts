import { NextResponse } from "next/server";
import { getImageGallery } from "../../lib/sanity";

// ✅ CORS Headers (For Reusability)
const corsHeaders = {
  "Content-Type": "application/json",
  "Access-Control-Allow-Origin": "*", // Allow all origins (Restrict in production)
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type",
};
export async function GET() {
    try {
      const data = await getImageGallery();
      return NextResponse.json(data, { headers: corsHeaders });
    } catch (error) {
      return NextResponse.json(
        { message: "Failed to fetch image gallery", error },
        { status: 500, headers: corsHeaders }
      );
    }
  }
export function OPTIONS() {
  return NextResponse.json(null, { status: 204, headers: corsHeaders });
}