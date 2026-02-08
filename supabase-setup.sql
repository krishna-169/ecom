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
