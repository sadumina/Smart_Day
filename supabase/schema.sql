create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

grant usage on schema public to authenticated;
grant select, insert, update, delete on table public.profiles to authenticated;

alter table public.profiles enable row level security;

drop policy if exists "Users can read their own profile" on public.profiles;
drop policy if exists "Users can create their own profile" on public.profiles;
drop policy if exists "Users can update their own profile" on public.profiles;
drop policy if exists "Users can delete their own profile" on public.profiles;

create policy "Users can read their own profile"
on public.profiles for select
using (auth.uid() = id);

create policy "Users can create their own profile"
on public.profiles for insert
with check (auth.uid() = id);

create policy "Users can update their own profile"
on public.profiles for update
using (auth.uid() = id)
with check (auth.uid() = id);

create policy "Users can delete their own profile"
on public.profiles for delete
using (auth.uid() = id);

create table if not exists public.projects (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  color text not null default '#4F46E5',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.tasks (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  description text,
  priority text not null default 'medium'
    check (priority in ('high', 'medium', 'low')),
  due_at timestamptz,
  project_id uuid references public.projects(id) on delete set null,
  status text not null default 'todo'
    check (status in ('todo', 'in_progress', 'done')),
  completed_subtasks integer not null default 0,
  total_subtasks integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.focus_sessions (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  task_id uuid references public.tasks(id) on delete set null,
  project_id uuid references public.projects(id) on delete set null,
  duration_minutes integer not null,
  started_at timestamptz not null,
  completed_at timestamptz
);

grant select, insert, update, delete on table
  public.projects, public.tasks, public.focus_sessions to authenticated;

alter table public.projects enable row level security;
alter table public.tasks enable row level security;
alter table public.focus_sessions enable row level security;

drop policy if exists "Users manage their own projects" on public.projects;
create policy "Users manage their own projects"
on public.projects for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "Users manage their own tasks" on public.tasks;
create policy "Users manage their own tasks"
on public.tasks for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "Users manage their own focus sessions"
on public.focus_sessions;
create policy "Users manage their own focus sessions"
on public.focus_sessions for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
