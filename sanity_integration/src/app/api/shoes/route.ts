import { NextResponse } from "next/server";
import { getShoes, createShoe, updateShoe, deleteShoe, getShoeById } from "../../lib/sanity";

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
      const product = await getShoeById(id);
      if (!product) {
        return NextResponse.json({ error: "Product not found" }, { status: 404, headers: corsHeaders });
      }
      return NextResponse.json(product, { status: 200, headers: corsHeaders });
    } else {
      const products = await getShoes();
      return NextResponse.json(products, { status: 200, headers: corsHeaders });
    }
  } catch (error) {
    console.error("Error fetching products:", error);
    return NextResponse.json({ error: "Failed to fetch products" }, { status: 500, headers: corsHeaders });
  }
}

// 🟢 Handle POST request (Create a new product)
export async function POST(req: Request) {
  try {
    if (req.bodyUsed) {
      const data = await req.json();

      // ✅ Input Validation
      if (!data.title || !data.description || typeof data.price !== "number") {
        return NextResponse.json({ error: "Missing or invalid product data" }, { status: 400 });
      }

      const newProduct = await createShoe(data);
      return NextResponse.json(newProduct, { status: 201, headers: corsHeaders });
    } else {
      return NextResponse.json({ error: "Request body is missing" }, { status: 400 });
    }
  } catch (error) {
    console.error("Error creating product:", error);
    return NextResponse.json({ error: "Failed to create product" }, { status: 500 });
  }
}

// 🟢 Handle PUT request (Update a product)
export async function PUT(req: Request) {
  try {
    if (req.bodyUsed) {
      const { id, ...data } = await req.json(); // Extract `id` from request

      // ✅ Check if ID is provided
      if (!id) {
        return NextResponse.json({ error: "Product ID is required" }, { status: 400 });
      }

      // ✅ Ensure at least one field is being updated
      if (Object.keys(data).length === 0) {
        return NextResponse.json({ error: "No update fields provided" }, { status: 400 });
      }

      const updatedProduct = await updateShoe(id, data);
      return NextResponse.json(updatedProduct, { status: 200, headers: corsHeaders });
    } else {
      return NextResponse.json({ error: "Request body is missing" }, { status: 400 });
    }
  } catch (error) {
    console.error("Error updating product:", error);
    return NextResponse.json({ error: "Failed to update product" }, { status: 500 });
  }
}

// 🟢 Handle DELETE request (Delete a product)
export async function DELETE(req: Request) {
  try {
    const body = await req.json();
    console.log("Received body:", body); // Log request body

    const { id } = body;

    if (!id) {
      return NextResponse.json({ error: "Product ID is required" }, { status: 400 });
    }

    console.log("Attempting to delete product with ID:", id); // Log the ID before deleting

    await deleteShoe(id);
    return NextResponse.json({ message: "Product deleted successfully" }, { status: 200 });
  } catch (error: unknown) {
    if (error instanceof Error) {
      console.error("Error deleting product:", error.message); // Log full error message
      return NextResponse.json({ error: "Failed to delete product", details: error.message }, { status: 500 });
    } else {
      console.error("Unknown error deleting product:", error);
      return NextResponse.json({ error: "Failed to delete product", details: "An unknown error occurred" }, { status: 500 });
    }
  }
}



// ✅ Handle OPTIONS Request (CORS Preflight)
export function OPTIONS() {
  return NextResponse.json(null, { status: 204, headers: corsHeaders });
}
