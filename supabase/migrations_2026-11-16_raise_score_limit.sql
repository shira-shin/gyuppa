-- 1000万点以上の記録が登録できない問題の修正（すでに schema.sql を実行済みのデータベース用）
-- Supabase の SQL Editor に貼り付けて Run。何度実行しても安全です。
--
-- 原因: 「遊んだ時間に対してありえない得点」の判定が「1秒あたり6万点まで」と一定だったが、
--       実際の得点は後半ほど急に伸びるため、上位の記録が弾かれていた。

alter table public.scores drop constraint if exists scores_score_check;
alter table public.scores add  constraint scores_score_check check (score between 1 and 2000000000);

alter table public.scores drop constraint if exists plausible_score;
alter table public.scores add  constraint plausible_score
  check (score <= duration * duration * 2500 + duration * 60000 + 50000);
