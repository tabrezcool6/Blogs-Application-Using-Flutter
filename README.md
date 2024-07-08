<!-- <<<<<<< HEAD -->
# Blogs-App-Using-Flutter
Blog application using S.O.L.I.D Principles and Clean Architecture
=======
# blogs_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
<!-- >>>>>>> 65f0baec7b0a20482d7966a683bb3ead7b6c0c08 -->

credits: 
All the topics and concepts here are learned and implemented from #Rivaan Ranawat


## 1. Code to create Blogs Table in Supabase Database

-- Create a table for public profiles
create table profiles (
  id uuid references auth.users not null primary key,
  updated_at timestamp with time zone,
  name text,

  constraint name_length check (char_length(name) >= 3)
);
-- Set up Row Level Security (RLS)
-- See https://supabase.com/docs/guides/database/postgres/row-level-security for more details.
alter table profiles
  enable row level security;

create policy "Public profiles are viewable by everyone." on profiles
  for select using (true);

create policy "Users can insert their own profile." on profiles
  for insert with check ((select auth.uid()) = id);

create policy "Users can update own profile." on profiles
  for update using ((select auth.uid()) = id);

-- This trigger automatically creates a profile entry when a new user signs up via Supabase Auth.
-- See https://supabase.com/docs/guides/auth/managing-user-data#using-triggers for more details.
create function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, name, timestamp)
  values (new.id, new.raw_user_meta_data->>'name', new.created_at->>'updated_at');
  return new;
end;
$$ language plpgsql security definer;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();




## 2. Code to create Blogs Table in Supabase Database

-- Create a table for public blogs
create table blogs (
  id uuid not null primary key,
  updated_at timestamp with time zone,
  poster_id uuid not null,
  title text not null,
  content text not null,
  image_url text,
  topics text[],
  foreign key (poster_id) references public.profiles(id)
);
-- Set up Row Level Security (RLS)
-- See https://supabase.com/docs/guides/database/postgres/row-level-security for more details.
alter table profiles
  enable row level security;

create policy "Public blogs are viewable by everyone." on blogs
  for select using (true);

create policy "Users can insert their own blogs." on blogs
  for insert with check ((select auth.uid()) = id);

create policy "Users can update own blogs." on blogs
  for update using ((select auth.uid()) = id);

-- Set up Storage!
insert into storage.buckets (id, name)
  values ('blog_images', 'blog_images');

-- Set up access controls for storage.
-- See https://supabase.com/docs/guides/storage/security/access-control#policy-examples for more details.
create policy "Avatar images are publicly accessible." on storage.objects
  for select using (bucket_id = 'blog_images');

create policy "Anyone can upload an avatar." on storage.objects
  for insert with check (bucket_id = 'blog_images');

create policy "Anyone can update their own avatar." on storage.objects
  for update using ((select auth.uid()) = owner) with check (bucket_id = 'blog_images');




## 3. How to add Log Out feature

Step 1: Create 'SignOut' Function in 'AuthRepository' class of Domain Layer

Step 2: Create 'SignOut' Function in interface class of 'AuthSupabaseDataSource' of Data Layer 

Step 3: Implement the above 'SignOut' Function in 'AuthSupabaseDataSourceImplementation' class and write the 'UserSignOut' function

Step 4: Implement the 'SignOut' Function of 'AuthRepository' in 'AuthRepositoryImplementation' class and call the 'SignOut' function of 'DataSource' class

Step 5: Create 'UserSignOut' UseCase class and call hte 'SignOut' Function from 'AuthRepository'

Step 6: Create an 'AuthSignOut' Event in  'Auth_Event' class in 'bloc' folder in Presentation Layer

Step 7: Create 'AuthSignOutSuccess' state in 'Auth_State' class

Step 8: import 'UserSignOut' class in 'AuthBloc' and call it through constructor. Write a function for 'AuthSignOut' and call 'SignOut' UseCase here.

Step 8: create a button to call LogOut Function and call this AuthSignOut Function from AuthBloc, show in 'blogs_page' under lib/features/blogs/presentation/pages/blogs_page.dart

note: refer the files mentioned above for complete code.
Also, feel free to write back for any corrections, suggestions, errors or any other thing...
>>>>>>>>


## 4. Added C.R.U.D Operation in the application
note: Please update the policies in the Supabase Database to make the functionalities work.

## 5. App Screen Shots

![alt text](<screenshots/1 sign_in.png>)
![alt text](<screenshots/2 sign_in.png>)
![alt text](<screenshots/3 sign_in.png>)
![alt text](<screenshots/4 sign_in.png>)
![alt text](<screenshots/5 sign_in.png>)
![alt text](<screenshots/6 sign_in.png>)