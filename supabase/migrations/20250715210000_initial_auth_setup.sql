-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create custom types
CREATE TYPE public.user_role AS ENUM ('admin', 'client');
CREATE TYPE public.order_status AS ENUM ('pending', 'in_progress', 'completed', 'cancelled');
CREATE TYPE public.currency_type AS ENUM ('FCFA', 'EUR', 'USD');
CREATE TYPE public.language_code AS ENUM ('fr', 'en', 'es');

-- Create user_profiles table as intermediary
CREATE TABLE public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    phone TEXT,
    role public.user_role DEFAULT 'client'::public.user_role,
    language public.language_code DEFAULT 'fr'::public.language_code,
    currency public.currency_type DEFAULT 'FCFA'::public.currency_type,
    avatar_url TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create services table
CREATE TABLE public.services (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    currency public.currency_type DEFAULT 'FCFA'::public.currency_type,
    category TEXT NOT NULL,
    image_url TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create orders table
CREATE TABLE public.orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    service_id UUID REFERENCES public.services(id) ON DELETE SET NULL,
    status public.order_status DEFAULT 'pending'::public.order_status,
    total_amount DECIMAL(10,2) NOT NULL,
    currency public.currency_type DEFAULT 'FCFA'::public.currency_type,
    order_details JSONB,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create order_messages table for admin responses
CREATE TABLE public.order_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES public.orders(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    message_type TEXT DEFAULT 'text',
    attachments JSONB,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create ai_chatbots table
CREATE TABLE public.ai_chatbots (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    settings JSONB DEFAULT '{}',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for performance
CREATE INDEX idx_user_profiles_email ON public.user_profiles(email);
CREATE INDEX idx_orders_user_id ON public.orders(user_id);
CREATE INDEX idx_orders_status ON public.orders(status);
CREATE INDEX idx_order_messages_order_id ON public.order_messages(order_id);
CREATE INDEX idx_ai_chatbots_user_id ON public.ai_chatbots(user_id);

-- Enable RLS
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.services ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_chatbots ENABLE ROW LEVEL SECURITY;

-- Helper functions
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.user_profiles up
    WHERE up.id = auth.uid() AND up.role = 'admin'::public.user_role
)
$$;

CREATE OR REPLACE FUNCTION public.owns_order(order_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.orders o
    WHERE o.id = order_uuid AND o.user_id = auth.uid()
)
$$;

CREATE OR REPLACE FUNCTION public.owns_chatbot(chatbot_uuid UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
SELECT EXISTS (
    SELECT 1 FROM public.ai_chatbots ac
    WHERE ac.id = chatbot_uuid AND ac.user_id = auth.uid()
)
$$;

-- RLS Policies
-- User profiles: users can view/edit their own profile, admins can view all
CREATE POLICY "users_own_profile" ON public.user_profiles
FOR ALL TO authenticated
USING (auth.uid() = id OR public.is_admin())
WITH CHECK (auth.uid() = id OR public.is_admin());

-- Services: public read access, admin write access
CREATE POLICY "services_public_read" ON public.services
FOR SELECT TO public
USING (is_active = true);

CREATE POLICY "services_admin_write" ON public.services
FOR ALL TO authenticated
USING (public.is_admin())
WITH CHECK (public.is_admin());

-- Orders: users can access their own orders, admins can access all
CREATE POLICY "orders_user_access" ON public.orders
FOR ALL TO authenticated
USING (public.owns_order(id) OR public.is_admin())
WITH CHECK (user_id = auth.uid() OR public.is_admin());

-- Order messages: accessible to order owner and admins
CREATE POLICY "order_messages_access" ON public.order_messages
FOR ALL TO authenticated
USING (
    public.owns_order(order_id) OR 
    public.is_admin() OR 
    sender_id = auth.uid()
)
WITH CHECK (
    public.owns_order(order_id) OR 
    public.is_admin() OR 
    sender_id = auth.uid()
);

-- AI Chatbots: users can manage their own chatbots
CREATE POLICY "chatbots_user_access" ON public.ai_chatbots
FOR ALL TO authenticated
USING (public.owns_chatbot(id) OR public.is_admin())
WITH CHECK (user_id = auth.uid() OR public.is_admin());

-- Function to handle new user registration
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.user_profiles (id, email, full_name, role)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
        COALESCE(NEW.raw_user_meta_data->>'role', 'client')::public.user_role
    );
    RETURN NEW;
END;
$$;

-- Trigger for new user creation
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

-- Triggers for updated_at
CREATE TRIGGER update_user_profiles_updated_at
    BEFORE UPDATE ON public.user_profiles
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_orders_updated_at
    BEFORE UPDATE ON public.orders
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_ai_chatbots_updated_at
    BEFORE UPDATE ON public.ai_chatbots
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- Mock data for testing
DO $$
DECLARE
    admin_uuid UUID := gen_random_uuid();
    user_uuid UUID := gen_random_uuid();
    service_uuid UUID := gen_random_uuid();
    order_uuid UUID := gen_random_uuid();
    chatbot_uuid UUID := gen_random_uuid();
BEGIN
    -- Create auth users
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
        created_at, updated_at, raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous, confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at, email_change_token_new, email_change,
        email_change_sent_at, email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at, phone, phone_change,
        phone_change_token, phone_change_sent_at
    ) VALUES
        (admin_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'admin@inno-v-group.com', crypt('admin123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Admin User", "role": "admin"}'::jsonb, 
         '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (user_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'client@example.com', crypt('client123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Client User", "role": "client"}'::jsonb,
         '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null);

    -- Create services
    INSERT INTO public.services (id, name, description, price, category, image_url) VALUES
        (service_uuid, 'Logo Design Premium', 'Création de logo professionnel avec révisions illimitées', 179.00, 'Design', 'https://images.unsplash.com/photo-1626785774573-4b799315345d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3'),
        (gen_random_uuid(), 'Site Web Responsive', 'Développement de site web moderne et responsive', 809.00, 'Web Development', 'https://images.pexels.com/photos/196644/pexels-photo-196644.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
        (gen_random_uuid(), 'Campagne Facebook Ads', 'Gestion complète de campagne publicitaire Facebook', 269.00, 'Marketing', 'https://images.pixabay.com/photo/2017/01/18/16/46/social-media-1989152_1280.jpg');

    -- Create sample order
    INSERT INTO public.orders (id, user_id, service_id, status, total_amount, order_details) VALUES
        (order_uuid, user_uuid, service_uuid, 'pending'::public.order_status, 179.00, 
         '{"specifications": "Logo moderne pour startup tech", "deadline": "2025-08-01"}'::jsonb);

    -- Create sample order message
    INSERT INTO public.order_messages (order_id, sender_id, message, message_type) VALUES
        (order_uuid, admin_uuid, 'Votre commande a été reçue et sera traitée dans les 24h.', 'text');

    -- Create sample AI chatbot
    INSERT INTO public.ai_chatbots (id, user_id, name, description, settings) VALUES
        (chatbot_uuid, user_uuid, 'Assistant Commercial', 'Chatbot pour support client et ventes', 
         '{"language": "fr", "personality": "professional", "features": ["whatsapp", "auto_response"]}'::jsonb);

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error creating mock data: %', SQLERRM;
END $$;