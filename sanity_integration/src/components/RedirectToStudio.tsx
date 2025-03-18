'use client'; // Ensure this runs on the client side

import { useEffect } from 'react';

export default function RedirectToStudio() {
  useEffect(() => {
      window.location.href = '/studio';
  }, []);
  return null;
}
