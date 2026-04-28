/*
  # Carevo — Initial Database Schema

  ## Overview
  Creates all core tables for the Carevo mobile car wash platform.

  ## New Tables

  ### 1. `profiles`
  - Extended user profile linked to Supabase auth.users
  - `id` (uuid, FK → auth.users)
  - `full_name` (text)
  - `phone` (text)
  - `role` (text: 'customer' | 'admin' | 'washer'), default 'customer'
  - `created_at` (timestamptz)

  ### 2. `services`
  - Car wash service catalog (dynamic, admin-managed)
  - `id`, `name`, `description`, `price`, `duration_minutes`, `image_url`, `is_active`, `sort_order`

  ### 3. `offers`
  - Promotional offers (dynamic, admin-managed)
  - `id`, `title`, `description`, `discount_percentage`, `is_active`, `start_date`, `end_date`, `image_url`

  ### 4. `orders`
  - Customer bookings/orders
  - `id`, `user_id`, `service_id`, `status`, `payment_status`, `location_address`, `location_lat`, `location_lng`, `scheduled_time`, `total_price`, `payment_proof_url`, `notes`, `created_at`, `updated_at`

  ### 5. `order_status_logs`
  - Audit trail for order status changes
  - `id`, `order_id`, `status`, `note`, `changed_by`, `created_at`

  ### 6. `config`
  - Dynamic key-value configuration (InstaPay, business settings)
  - `key` (text, PK), `value` (text), `updated_at`

  ## Security
  - RLS enabled on ALL tables
  - Profiles: users read/update own profile only
  - Services/Offers: public read, admin write
  - Config: public read, admin write
  - Orders: users see own orders, admin sees all
  - Order status logs: users read own, admin write

  ## Indexes
  - orders: user_id, status, created_at DESC
  - order_status_logs: order_id
  - services: is_active
  - offers: is_active, start_date, end_date
*/

-- ─────────────────────────────────────────────
-- PROFILES
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS profiles (
  id         uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name  text NOT NULL DEFAULT '',
  phone      text NOT NULL DEFAULT '',
  role       text NOT NULL DEFAULT 'customer' CHECK (role IN ('customer', 'admin', 'washer')),
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can insert own profile"
  ON profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Admins can view all profiles"
  ON profiles FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid() AND p.role IN ('admin', 'washer')
    )
  );

-- ─────────────────────────────────────────────
-- SERVICES
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS services (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name             text NOT NULL,
  description      text NOT NULL DEFAULT '',
  price            numeric(10, 2) NOT NULL CHECK (price >= 0),
  duration_minutes integer NOT NULL DEFAULT 30 CHECK (duration_minutes > 0),
  image_url        text NOT NULL DEFAULT '',
  is_active        boolean NOT NULL DEFAULT true,
  sort_order       integer NOT NULL DEFAULT 0,
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_services_is_active ON services(is_active);
CREATE INDEX IF NOT EXISTS idx_services_sort_order ON services(sort_order);

ALTER TABLE services ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view active services"
  ON services FOR SELECT
  USING (is_active = true);

CREATE POLICY "Admins can view all services"
  ON services FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid() AND p.role = 'admin'
    )
  );

CREATE POLICY "Admins can insert services"
  ON services FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid() AND p.role = 'admin'
    )
  );

CREATE POLICY "Admins can update services"
  ON services FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid() AND p.role = 'admin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid() AND p.role = 'admin'
    )
  );

CREATE POLICY "Admins can delete services"
  ON services FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid() AND p.role = 'admin'
    )
  );

-- ─────────────────────────────────────────────
-- OFFERS
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS offers (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title               text NOT NULL,
  description         text NOT NULL DEFAULT '',
  discount_percentage numeric(5, 2) NOT NULL DEFAULT 0 CHECK (discount_percentage >= 0 AND discount_percentage <= 100),
  is_active           boolean NOT NULL DEFAULT true,
  start_date          date,
  end_date            date,
  image_url           text NOT NULL DEFAULT '',
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_offers_is_active ON offers(is_active);
CREATE INDEX IF NOT EXISTS idx_offers_dates ON offers(start_date, end_date);

ALTER TABLE offers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view active offers"
  ON offers FOR SELECT
  USING (
    is_active = true
    AND (start_date IS NULL OR start_date <= CURRENT_DATE)
    AND (end_date IS NULL OR end_date >= CURRENT_DATE)
  );

CREATE POLICY "Admins can view all offers"
  ON offers FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid() AND p.role = 'admin'
    )
  );

CREATE POLICY "Admins can insert offers"
  ON offers FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid() AND p.role = 'admin'
    )
  );

CREATE POLICY "Admins can update offers"
  ON offers FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid() AND p.role = 'admin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid() AND p.role = 'admin'
    )
  );

CREATE POLICY "Admins can delete offers"
  ON offers FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid() AND p.role = 'admin'
    )
  );

-- ─────────────────────────────────────────────
-- ORDERS
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS orders (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           uuid NOT NULL REFERENCES auth.users(id) ON DELETE RESTRICT,
  service_id        uuid NOT NULL REFERENCES services(id) ON DELETE RESTRICT,
  status            text NOT NULL DEFAULT 'pending'
                    CHECK (status IN ('pending', 'confirmed', 'on_the_way', 'in_progress', 'completed', 'cancelled')),
  payment_status    text NOT NULL DEFAULT 'unpaid'
                    CHECK (payment_status IN ('unpaid', 'pending_verification', 'paid', 'refunded')),
  location_address  text NOT NULL DEFAULT '',
  location_lat      numeric(10, 7),
  location_lng      numeric(10, 7),
  scheduled_time    timestamptz NOT NULL,
  total_price       numeric(10, 2) NOT NULL CHECK (total_price >= 0),
  payment_proof_url text,
  notes             text NOT NULL DEFAULT '',
  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_orders_user_id ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_created_at_desc ON orders(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_service_id ON orders(service_id);

ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own orders"
  ON orders FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own orders"
  ON orders FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admins can view all orders"
  ON orders FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid() AND p.role IN ('admin', 'washer')
    )
  );

CREATE POLICY "Admins can update any order"
  ON orders FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid() AND p.role IN ('admin', 'washer')
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid() AND p.role IN ('admin', 'washer')
    )
  );

CREATE POLICY "Users can update own order payment proof"
  ON orders FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ─────────────────────────────────────────────
-- ORDER STATUS LOGS
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS order_status_logs (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id   uuid NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  status     text NOT NULL,
  note       text NOT NULL DEFAULT '',
  changed_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_order_status_logs_order_id ON order_status_logs(order_id);

ALTER TABLE order_status_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view logs for own orders"
  ON order_status_logs FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM orders o
      WHERE o.id = order_id AND o.user_id = auth.uid()
    )
  );

CREATE POLICY "Admins can view all status logs"
  ON order_status_logs FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid() AND p.role IN ('admin', 'washer')
    )
  );

CREATE POLICY "Admins can insert status logs"
  ON order_status_logs FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid() AND p.role IN ('admin', 'washer')
    )
  );

-- ─────────────────────────────────────────────
-- CONFIG (key-value store for dynamic settings)
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS config (
  key        text PRIMARY KEY,
  value      text NOT NULL DEFAULT '',
  updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE config ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read config"
  ON config FOR SELECT
  USING (true);

CREATE POLICY "Admins can insert config"
  ON config FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid() AND p.role = 'admin'
    )
  );

CREATE POLICY "Admins can update config"
  ON config FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid() AND p.role = 'admin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles p
      WHERE p.id = auth.uid() AND p.role = 'admin'
    )
  );

-- ─────────────────────────────────────────────
-- SEED CONFIG with default keys
-- ─────────────────────────────────────────────
INSERT INTO config (key, value) VALUES
  ('instapay_number',       '01000000000'),
  ('instapay_link',         'https://ipn.eg/S/carevo'),
  ('payment_instructions',  'يرجى تحويل المبلغ عبر InstaPay ثم رفع صورة الإيصال.'),
  ('service_radius',        '20'),
  ('working_hours',         '08:00-22:00')
ON CONFLICT (key) DO NOTHING;

-- ─────────────────────────────────────────────
-- SEED SAMPLE SERVICES
-- ─────────────────────────────────────────────
INSERT INTO services (name, description, price, duration_minutes, image_url, is_active, sort_order) VALUES
  ('Basic Wash',    'Exterior wash with water and soap. Rinse and dry.',         79.00,  30, 'https://images.pexels.com/photos/6873073/pexels-photo-6873073.jpeg', true, 1),
  ('Premium Wash',  'Full exterior + interior wipe down. Dashboard clean.',      149.00, 60, 'https://images.pexels.com/photos/3822843/pexels-photo-3822843.jpeg', true, 2),
  ('Deep Clean',    'Full interior vacuum, seat cleaning, and exterior polish.', 249.00, 90, 'https://images.pexels.com/photos/1149831/pexels-photo-1149831.jpeg', true, 3),
  ('Express Shine', 'Quick 20-min exterior rinse and spray wax.',                59.00,  20, 'https://images.pexels.com/photos/9462291/pexels-photo-9462291.jpeg', true, 4)
ON CONFLICT DO NOTHING;

-- ─────────────────────────────────────────────
-- SEED SAMPLE OFFERS
-- ─────────────────────────────────────────────
INSERT INTO offers (title, description, discount_percentage, is_active, start_date, end_date, image_url) VALUES
  ('First Wash Free!',    'Get 20% off your first booking with Carevo.',  20.00, true, CURRENT_DATE, CURRENT_DATE + INTERVAL '30 days', 'https://images.pexels.com/photos/6873073/pexels-photo-6873073.jpeg'),
  ('Weekend Special',     'Book Saturday or Sunday for 15% off any wash.', 15.00, true, CURRENT_DATE, CURRENT_DATE + INTERVAL '90 days', 'https://images.pexels.com/photos/3822843/pexels-photo-3822843.jpeg')
ON CONFLICT DO NOTHING;

-- ─────────────────────────────────────────────
-- AUTO-UPDATE updated_at via trigger
-- ─────────────────────────────────────────────
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER services_updated_at
  BEFORE UPDATE ON services
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER offers_updated_at
  BEFORE UPDATE ON offers
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER orders_updated_at
  BEFORE UPDATE ON orders
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
