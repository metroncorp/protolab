create table if not exists user (
    id serial primary key,
    email varchar(255) not null,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);


create table if not exists organization (
    id serial primary key,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table if not exists integration (
    id serial primary key,
    organization_id int not null,
    namespace varchar(1024) not null,
    spec jsonb not null,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table if not exists project (
    id serial primary key,
    organization_id int not null,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table if not exists org_user (
    id serial primary key,
    organization_id int not null,
    user_id int not null,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table if not exists tenant (
    id serial primary key,
    organization_id int not null,
    project_id int not null,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table if not exists supplier (
    id serial primary key,
    organization_id int not null,
    project_id int not null,
    tenant_id int not null,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table if not exists retailer (
    id serial primary key,
    organization_id int not null,
    project_id int not null,
    tenant_id int not null,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table if not exists retailer_agreement (
    id serial primary key,
    organization_id int not null,
    project_id int not null,
    retailer_id int not null,
    supplier_id int not null,
    spec jsonb not null,
    lifecycle_state varchar(255) not null,
    activated_at timestamptz,
    terminated_at timestamptz,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table if not exists store (
    id serial primary key,
    organization_id int not null,
    project_id int not null,
    tenant_id int not null,
    retailer_id int not null,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);