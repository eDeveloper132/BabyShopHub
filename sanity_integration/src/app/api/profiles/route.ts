import { NextResponse } from "next/server";
import { getProfile, createProfile, updateProfile, deleteProfile } from "../../lib/sanity";

// ✅ CORS Headers (For Reusability)
const corsHeaders = {
  "Content-Type": "application/json",
  "Access-Control-Allow-Origin": "*", // Allow all origins (Restrict in production)
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type",
};

// 🟢 Handle GET request (Fetch user profile by email)
export async function GET(req: Request) {
  try {
    const { searchParams } = new URL(req.url);
    const email = searchParams.get("email");

    if (!email) {
      return NextResponse.json({ error: "Email is required" }, { status: 400 });
    }

    const profile = await getProfile(email);
    if (!profile) {
      return NextResponse.json({ error: "Profile not found" }, { status: 404 });
    }

    return NextResponse.json(profile, { status: 200, headers: corsHeaders });
  } catch (error) {
    console.error("Error fetching profile:", error);
    return NextResponse.json({ error: "Failed to fetch profile" }, { status: 500 });
  }
}

// 🟢 Handle POST request (Create a new user profile)
export async function POST(req: Request) {
  try {
    const data = await req.json();

    // ✅ Validate required email field
    if (!data.email) {
      return NextResponse.json({ error: "Email is required" }, { status: 400 });
    }

    const newProfile = await createProfile(data);
    return NextResponse.json(newProfile, { status: 201, headers: corsHeaders });
  } catch (error) {
    console.error("Error creating profile:", error);
    return NextResponse.json({ error: "Failed to create profile" }, { status: 500 });
  }
}

// 🟢 Handle PUT request (Update user profile)
export async function PUT(req: Request) {
  try {
    const { id, ...data } = await req.json();

    // ✅ Ensure ID is provided
    if (!id) {
      return NextResponse.json({ error: "Profile ID is required" }, { status: 400 });
    }

    // ✅ Ensure at least one field is being updated
    if (Object.keys(data).length === 0) {
      return NextResponse.json({ error: "No update fields provided" }, { status: 400 });
    }

    const updatedProfile = await updateProfile(id, data);
    return NextResponse.json(updatedProfile, { status: 200, headers: corsHeaders });
  } catch (error) {
    console.error("Error updating profile:", error);
    return NextResponse.json({ error: "Failed to update profile" }, { status: 500 });
  }
}

// 🟢 Handle DELETE request (Delete user profile)
export async function DELETE(req: Request) {
  try {
    const { id } = await req.json();

    if (!id) {
      return NextResponse.json({ error: "Profile ID is required" }, { status: 400 });
    }

    await deleteProfile(id);
    return NextResponse.json({ message: "Profile deleted successfully" }, { status: 200 });
  } catch (error) {
    console.error("Error deleting profile:", error);
    return NextResponse.json({ error: "Failed to delete profile" }, { status: 500 });
  }
}

// ✅ Handle OPTIONS Request (CORS Preflight)
export function OPTIONS() {
  return NextResponse.json(null, { status: 204, headers: corsHeaders });
}
