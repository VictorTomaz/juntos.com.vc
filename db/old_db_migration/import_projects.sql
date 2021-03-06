/* Remove duplicated urls */
UPDATE old_db.juntoscomvc_projeto SET url = 'brincarumdireitodacrianca-2' WHERE "projetoId" = '10013FE5-5311-46FD-81C2-957DEDD4C733';
UPDATE old_db.juntoscomvc_projeto SET url = 'cartaelivro-2' WHERE "projetoId" = '58E96A45-B600-4D1C-A0A1-2C274000CE3B';
UPDATE old_db.juntoscomvc_projeto SET url = 'ios-1' WHERE "projetoId" = 'DE8404A9-B92E-4112-AD59-ACA0BE9F47C5';

/* Import online projects */
INSERT INTO projects (
  uuid,
  category_id,
  user_id,
  name,
  headline,
  goal,
  permalink,
  online_days,
  about,
  about_html,
  video_url,
  thank_you,
  created_at,
  updated_at,
  online_date,
  state
) SELECT
  "projetoId",
  categories.id,
  users.id,
  nome,
  substr(descricao, 0, 140),
  ("metaValor"::float::integer),
  url,
  tempo::integer,
  "descricao",
  "descricao",
  video,
  agradecimento,
  "dataCadastro",
  "dataAlteracao",
  "dataAtivacao",
  'online'
FROM "old_db"."juntoscomvc_projeto" as old_projects
JOIN users
  ON users.uuid = old_projects."clienteId"
JOIN categories
  ON categories.uuid = old_projects."categoriaprojetoId"
WHERE ativo = 'true'
  AND "dataAtivacao" is not null;

/* Import drafts */
INSERT INTO projects (
  uuid,
  category_id,
  user_id,
  name,
  headline,
  goal,
  permalink,
  online_days,
  about,
  about_html,
  video_url,
  thank_you,
  created_at,
  updated_at,
  online_date,
  state
) SELECT
  "projetoId",
  categories.id,
  users.id,
  nome,
  CASE WHEN descricao != '' then substr(descricao, 0, 140) else 'placeholder headline' end,
  ("metaValor"::float::integer),
  CASE WHEN url != '' THEN url ELSE "projetoId" END,
  tempo::integer,
  CASE WHEN "descricao" != '' THEN descricao ELSE 'placeholder about' END,
  CASE WHEN "descricao" != '' THEN descricao ELSE 'placeholder agout' END,
  video,
  agradecimento,
  "dataCadastro",
  "dataAlteracao",
  "dataAtivacao",
  'draft'
FROM "old_db"."juntoscomvc_projeto" as old_projects
JOIN users
  ON users.uuid = old_projects."clienteId"
JOIN categories
  ON categories.uuid = old_projects."categoriaprojetoId"
WHERE ativo = 'true'
  AND "dataAtivacao" is null
  AND "dataAvaliacaoPasso2" > '2013-01-01';




/* Add the Garupa category */
INSERT INTO categories (
  name_pt,
  created_at,
  updated_at,
  color
) VALUES (
  'Garupa',
  '2013-01-01 00:00:00',
  '2013-01-01 00:00:00',
  '#b8292a'
);

/* Add the garupa channel */
INSERT INTO channels (
  name,
  permalink,
  description,
  created_at,
  updated_at,
  category_id
) VALUES (
  'Garupa',
  'garupa',
  'Canal garupa',
  '2013-01-01 00:00:00',
  '2013-01-01 00:00:00',
  (select id from categories where name_pt = 'Garupa')
);

/* Import garupa projects */
INSERT INTO projects (
  uuid,
  category_id,
  user_id,
  name,
  headline,
  goal,
  permalink,
  online_days,
  about,
  about_html,
  video_url,
  thank_you,
  created_at,
  updated_at,
  online_date,
  state
) SELECT
  "projetoId",
  categories.id,
  users.id,
  nome,
  substr(descricao, 0, 140),
  ("metaValor"::float::integer),
  url,
  tempo::integer,
  "descricao",
  "descricao",
  video,
  agradecimento,
  "dataCadastro",
  "dataAlteracao",
  "dataAtivacao",
  'online'
FROM "old_db"."garupa_projeto" as old_projects
JOIN users
  ON users.email = (SELECT email FROM old_db.garupa_cliente WHERE old_db.garupa_cliente."clienteId" = old_projects."clienteId")
JOIN categories
  ON categories.name_pt = 'Garupa'
WHERE ativo = 'true'
  AND "dataAtivacao" is not null;

/* Import garupa drafts */
INSERT INTO projects (
  uuid,
  category_id,
  user_id,
  name,
  headline,
  goal,
  permalink,
  online_days,
  about,
  about_html,
  video_url,
  thank_you,
  created_at,
  updated_at,
  online_date,
  state
) SELECT
  "projetoId",
  categories.id,
  users.id,
  nome,
  substr(descricao, 0, 140),
  ("metaValor"::float::integer),
  url,
  tempo::integer,
  "descricao",
  "descricao",
  video,
  agradecimento,
  "dataCadastro",
  "dataAlteracao",
  "dataAtivacao",
  'draft'
FROM "old_db"."garupa_projeto" as old_projects
JOIN users
  ON users.email = (SELECT email FROM old_db.garupa_cliente WHERE old_db.garupa_cliente."clienteId" = old_projects."clienteId")
JOIN categories
  ON categories.name_pt = 'Garupa'
WHERE ativo = 'true'
  AND "dataAtivacao" is null
  AND "dataAvaliacaoPasso2" > '2013-01-01';
