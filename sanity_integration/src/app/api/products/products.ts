import { client } from "@/sanity/lib/client";
export function getProducts() {
    const Data = client.fetch('*[_type == "product"]');
    return Data
}