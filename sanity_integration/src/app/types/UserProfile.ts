export type UserProfile = {
  _id?: string; // Optional Sanity document ID
  email: string;
  username?: string;
  address?: string;
  postalCode?: string;
  phoneNumber?: string;
  dateOfBirth?: string;
  profileImage?: { asset: { _ref: string } };
  pastOrders?: {
    orderId: string;
    orderDate: string;
    totalAmount: number;
    status: "pending" | "completed" | "cancelled";
  }[];
};