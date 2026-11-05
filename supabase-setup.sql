-- Run this entire script in Supabase → SQL Editor → New query → Run.
-- One private workspace row per authenticated user.
create table if not exists public.gate_da_progress (
  user_id uuid primary key references auth.users(id) on delete cascade,
  workspace jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.gate_da_progress enable row level security;

drop policy if exists "Users can read their own GATE progress" on public.gate_da_progress;
create policy "Users can read their own GATE progress"
on public.gate_da_progress for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "Users can insert their own GATE progress" on public.gate_da_progress;
create policy "Users can insert their own GATE progress"
on public.gate_da_progress for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Users can update their own GATE progress" on public.gate_da_progress;
create policy "Users can update their own GATE progress"
on public.gate_da_progress for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

grant select, insert, update on public.gate_da_progress to authenticated;
