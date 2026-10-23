-- =========================================================================
-- SUPABASE POSTGRESQL SCHEMA FOR SWIGGY FOOD & DINING APP
-- Copy and paste this script into your Supabase Dashboard SQL Editor & click Run!
-- =========================================================================

-- 1. Create Menu Items Table
CREATE TABLE IF NOT EXISTS public.menu_items (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL,
    rating NUMERIC(3,2) DEFAULT 4.8,
    review_count INT DEFAULT 100,
    category_id TEXT DEFAULT 'burgers',
    image_url TEXT,
    calories INT DEFAULT 500,
    prep_time TEXT DEFAULT '20 mins',
    distance TEXT DEFAULT '2.0 km',
    is_popular BOOLEAN DEFAULT false,
    is_veg BOOLEAN DEFAULT true,
    restaurant_name TEXT DEFAULT 'Savoria Bistro',
    offer_tag TEXT DEFAULT '50% OFF UP TO ₹100',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable Row Level Security (RLS) & allow public Read
ALTER TABLE public.menu_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow Public Read on menu_items" ON public.menu_items FOR SELECT USING (true);

-- 2. Insert Sample Food Items
INSERT INTO public.menu_items (id, name, description, price, rating, review_count, category_id, image_url, calories, prep_time, distance, is_popular, is_veg, restaurant_name, offer_tag)
VALUES
('m1', 'Hyderabadi Dum Chicken Biryani', 'Fragrant basmati rice dum cooked with tender chicken, saffron, and aromatic spices.', 13.99, 4.8, 1250, 'biryani', 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=800&q=80', 680, '25-30 mins', '1.8 km', true, false, 'Paradise Biryani House', '60% OFF UP TO ₹120'),
('m2', 'Truffle Angus Smash Burger', 'Double smashed Angus beef patty, black truffle aioli, caramelised onions, Swiss cheese on brioche bun.', 14.99, 4.9, 320, 'burgers', 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=800&q=80', 780, '15-20 mins', '2.5 km', true, false, 'The Burger Club', '50% OFF UP TO ₹100'),
('m3', 'Paneer Butter Masala & Naan', 'Cottage cheese cubes simmered in a rich, buttery tomato cashew gravy with 2 Garlic Butter Naans.', 12.50, 4.7, 890, 'north_indian', 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=800&q=80', 620, '20-25 mins', '1.2 km', true, true, 'Punjabi Rasoi', 'FLAT ₹125 OFF'),
('m4', 'Artisan Wood-Fired Margherita', 'Sourdough crust topped with San Marzano tomato sauce, fresh buffalo mozzarella, and basil.', 15.99, 4.8, 450, 'pizza', 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?auto=format&fit=crop&w=800&q=80', 650, '20 mins', '3.1 km', true, true, 'Pizza Italia Oven', 'BUY 1 GET 1 FREE')
ON CONFLICT (id) DO NOTHING;

-- 3. Create Orders Table
CREATE TABLE IF NOT EXISTS public.orders (
    id TEXT PRIMARY KEY,
    items JSONB NOT NULL,
    subtotal NUMERIC(10,2) NOT NULL,
    delivery_fee NUMERIC(10,2) DEFAULT 0.00,
    tax NUMERIC(10,2) NOT NULL,
    total NUMERIC(10,2) NOT NULL,
    status TEXT DEFAULT 'placed',
    delivery_address TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow Public Read/Write on orders" ON public.orders FOR ALL USING (true);

-- 4. Create Table Reservations Table
CREATE TABLE IF NOT EXISTS public.reservations (
    id TEXT PRIMARY KEY,
    date TIMESTAMP WITH TIME ZONE NOT NULL,
    time_slot TEXT NOT NULL,
    party_size INT NOT NULL,
    seating_preference TEXT,
    special_request TEXT,
    status TEXT DEFAULT 'confirmed',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.reservations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow Public Read/Write on reservations" ON public.reservations FOR ALL USING (true);
