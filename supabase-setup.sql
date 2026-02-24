-- Product Reviews & Ratings
create table if not exists public.reviews (
    id uuid primary key default gen_random_uuid(),
    product_id uuid references public.products(id) on delete cascade,
    user_id uuid references auth.users(id) on delete cascade,
    rating integer not null check (rating >= 1 and rating <= 5),
    text text,
    created_at timestamp with time zone default now()
);

alter table public.reviews enable row level security;

drop policy if exists "Reviews are viewable by everyone" on public.reviews;
drop policy if exists "Reviews are insertable by owner" on public.reviews;

create policy "Reviews are viewable by everyone"
    on public.reviews
    for select
    using (true);

create policy "Reviews are insertable by owner"
    on public.reviews
    for insert
    with check (auth.uid() = user_id);
create extension if not exists "pgcrypto";

-- Profiles table for OTP users
create table if not exists public.profiles (
    id uuid primary key references auth.users(id) on delete cascade,
    full_name text,
    email text,
    phone text,
    location text,
    created_at timestamp with time zone default now()
);

alter table public.profiles add column if not exists email text;

alter table public.profiles enable row level security;

drop policy if exists "Profiles are viewable by owner" on public.profiles;
drop policy if exists "Profiles are insertable by owner" on public.profiles;
drop policy if exists "Profiles are updatable by owner" on public.profiles;

create policy "Profiles are viewable by owner"
    on public.profiles
    for select
    using (auth.uid() = id);

create policy "Profiles are insertable by owner"
    on public.profiles
    for insert
    with check (auth.uid() = id);

create policy "Profiles are updatable by owner"
    on public.profiles
    for update
    using (auth.uid() = id);

-- Products table
create table if not exists public.products (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references auth.users(id) on delete set null,
    name text not null,
    price numeric,
    tags text,
    category text,
    size text,
    condition text,
    color text,
    material text,
    location text,
    seller_phone text,
    description text,
    image_url text,
    tryon_url text,
    created_at timestamp with time zone default now()
);

alter table public.products enable row level security;

drop policy if exists "Products are viewable by everyone" on public.products;
drop policy if exists "Products are insertable by owner" on public.products;
drop policy if exists "Products are updatable by owner" on public.products;
drop policy if exists "Products are deletable by owner" on public.products;

create policy "Products are viewable by everyone"
    on public.products
    for select
    using (true);

create policy "Products are insertable by owner"
    on public.products
    for insert
    with check (auth.uid() = user_id);

create policy "Products are updatable by owner"
    on public.products
    for update
    using (auth.uid() = user_id);

create policy "Products are deletable by owner"
    on public.products
    for delete
    using (auth.uid() = user_id);

-- Liked items
create table if not exists public.liked_items (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references auth.users(id) on delete cascade,
    product_id uuid references public.products(id) on delete cascade,
    created_at timestamp with time zone default now(),
    unique (user_id, product_id)
);

alter table public.liked_items enable row level security;

drop policy if exists "Liked items are viewable by owner" on public.liked_items;
drop policy if exists "Liked items are insertable by owner" on public.liked_items;
drop policy if exists "Liked items are deletable by owner" on public.liked_items;

create policy "Liked items are viewable by owner"
    on public.liked_items
    for select
    using (auth.uid() = user_id);

create policy "Liked items are insertable by owner"
    on public.liked_items
    for insert
    with check (auth.uid() = user_id);

create policy "Liked items are deletable by owner"
    on public.liked_items
    for delete
    using (auth.uid() = user_id);

-- Cart items
create table if not exists public.cart_items (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references auth.users(id) on delete cascade,
    product_id uuid references public.products(id) on delete cascade,
    quantity integer default 1,
    created_at timestamp with time zone default now(),
    unique (user_id, product_id)
);

alter table public.cart_items enable row level security;

drop policy if exists "Cart items are viewable by owner" on public.cart_items;
drop policy if exists "Cart items are insertable by owner" on public.cart_items;
drop policy if exists "Cart items are updatable by owner" on public.cart_items;
drop policy if exists "Cart items are deletable by owner" on public.cart_items;

create policy "Cart items are viewable by owner"
    on public.cart_items
    for select
    using (auth.uid() = user_id);

create policy "Cart items are insertable by owner"
    on public.cart_items
    for insert
    with check (auth.uid() = user_id);

create policy "Cart items are updatable by owner"
    on public.cart_items
    for update
    using (auth.uid() = user_id);

create policy "Cart items are deletable by owner"
    on public.cart_items
    for delete
    using (auth.uid() = user_id);
