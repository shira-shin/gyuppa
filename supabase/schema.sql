-- ギュッパ 全国番付のテーブル
-- Supabase の SQL Editor に貼り付けて一度だけ実行する。

create table if not exists public.scores (
  id         bigint generated always as identity primary key,
  name       text        not null check (char_length(btrim(name)) between 1 and 12),
  score      integer     not null check (score between 1 and 2000000000),  -- 約20億（integer の上限の手前）
  max_chain  integer     not null default 0 check (max_chain between 0 and 999),
  act        integer     not null default 1 check (act between 1 and 999),
  duration   real        not null check (duration between 3 and 7200),  -- 遊んだ秒数
  created_at timestamptz not null default now(),
  -- 遊んだ時間に対してありえない高得点は受け付けない。
  -- 得点は後半ほど急に伸びる（1回の爆発の得点が巻き込んだ数の2乗に近づく）ので、時間の2乗に比例する余裕を持たせる。
  constraint plausible_score check (score <= duration * duration * 2500 + duration * 60000 + 50000)
);

create index if not exists scores_score_idx on public.scores (score desc, created_at asc);

-- だれでも読める・追加できる。変更と削除はできない
alter table public.scores enable row level security;
drop policy if exists "read scores" on public.scores;
drop policy if exists "add scores"  on public.scores;
create policy "read scores" on public.scores for select to anon using (true);
create policy "add scores"  on public.scores for insert to anon with check (true);
grant select, insert on public.scores to anon;

-- 大量送信の歯止め：全体で1分あたり120件まで
create or replace function public.scores_rate_limit() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if (select count(*) from public.scores where created_at > now() - interval '1 minute') >= 120 then
    raise exception 'too many submissions, try again later';
  end if;
  new.created_at := now();   -- 日時は送り手に決めさせない
  return new;
end $$;
drop trigger if exists scores_rate_limit on public.scores;
create trigger scores_rate_limit before insert on public.scores
  for each row execute function public.scores_rate_limit();
