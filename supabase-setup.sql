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

-- Private screenshot storage for per-topic study notes.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('topic-notes', 'topic-notes', false, 8388608, array['image/jpeg','image/png','image/webp','image/gif'])
on conflict (id) do update set
  public = false,
  file_size_limit = 8388608,
  allowed_mime_types = array['image/jpeg','image/png','image/webp','image/gif'];

drop policy if exists "Users can view their own topic screenshots" on storage.objects;
create policy "Users can view their own topic screenshots"
on storage.objects for select to authenticated
using (bucket_id = 'topic-notes' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "Users can upload their own topic screenshots" on storage.objects;
create policy "Users can upload their own topic screenshots"
on storage.objects for insert to authenticated
with check (bucket_id = 'topic-notes' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "Users can delete their own topic screenshots" on storage.objects;
create policy "Users can delete their own topic screenshots"
on storage.objects for delete to authenticated
using (bucket_id = 'topic-notes' and (storage.foldername(name))[1] = auth.uid()::text);
