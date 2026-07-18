-- ============================================================
-- CAMPUS AI HUB - Complete Database Migration Script
-- ============================================================
-- Run this ENTIRE script in your new Supabase project's SQL Editor
-- (Supabase Dashboard → SQL Editor → New Query → Paste → Run)
-- ============================================================

-- ============================================================
-- 1. ENABLE EXTENSIONS
-- ============================================================
CREATE EXTENSION IF NOT EXISTS vector WITH SCHEMA extensions;

-- ============================================================
-- 2. PROFILES TABLE
-- ============================================================
CREATE TABLE public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  full_name TEXT,
  gender TEXT,
  dob DATE,
  mobile TEXT,
  father_name TEXT,
  mother_name TEXT,
  parent_mobile TEXT,
  blood_group TEXT,
  roll_number TEXT,
  admission_number TEXT,
  batch TEXT,
  degree TEXT,
  program_code TEXT,
  semester TEXT,
  section TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email)
  VALUES (NEW.id, NEW.email);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- ============================================================
-- 3. CHAT SESSIONS TABLE
-- ============================================================
CREATE TABLE public.chat_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  title TEXT DEFAULT 'New Conversation',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 4. MESSAGES TABLE (AI Chat)
-- ============================================================
CREATE TABLE public.messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  session_id UUID REFERENCES public.chat_sessions(id) ON DELETE CASCADE NOT NULL,
  text TEXT NOT NULL,
  is_bot BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 5. EVENTS TABLE (Calendar/Schedule)
-- ============================================================
CREATE TABLE public.events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  start_time TIMESTAMPTZ,
  end_time TIMESTAMPTZ,
  description TEXT,
  is_important BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 6. VAULT ITEMS TABLE
-- ============================================================
CREATE TABLE public.vault_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  filename TEXT NOT NULL,
  file_path TEXT NOT NULL,
  file_type TEXT,
  category TEXT DEFAULT 'Other',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 7. CONNECTIONS TABLE (Social Network)
-- ============================================================
CREATE TABLE public.connections (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  requester_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  receiver_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 8. DIRECT MESSAGES TABLE
-- ============================================================
CREATE TABLE public.direct_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  receiver_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER PUBLICATION supabase_realtime ADD TABLE public.direct_messages;

-- ============================================================
-- 9. DOCUMENTS TABLE (AI Vector Store / RAG)
-- ============================================================
CREATE TABLE public.documents (
  id BIGSERIAL PRIMARY KEY,
  content TEXT,
  metadata JSONB,
  embedding VECTOR(768)
);

CREATE INDEX ON public.documents
  USING ivfflat (embedding vector_cosine_ops)
  WITH (lists = 100);

-- ============================================================
-- 10. MATCH_DOCUMENTS FUNCTION (Vector Search RPC)
-- ============================================================
CREATE OR REPLACE FUNCTION public.match_documents(
  query_embedding VECTOR(768),
  match_threshold FLOAT,
  match_count INT
)
RETURNS TABLE (
  id BIGINT,
  content TEXT,
  metadata JSONB,
  similarity FLOAT
)
LANGUAGE sql STABLE
AS $$
  SELECT
    documents.id,
    documents.content,
    documents.metadata,
    1 - (documents.embedding <=> query_embedding) AS similarity
  FROM documents
  WHERE 1 - (documents.embedding <=> query_embedding) > match_threshold
  ORDER BY (documents.embedding <=> query_embedding)
  LIMIT match_count;
$$;

-- ============================================================
-- 11. ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view profiles" ON public.profiles FOR SELECT USING (true);
CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert own profile" ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);

ALTER TABLE public.chat_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own chat sessions" ON public.chat_sessions FOR ALL USING (auth.uid() = user_id);

ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own messages" ON public.messages FOR ALL USING (auth.uid() = user_id);

ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own events" ON public.events FOR ALL USING (auth.uid() = user_id);

ALTER TABLE public.vault_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own vault items" ON public.vault_items FOR ALL USING (auth.uid() = user_id);

ALTER TABLE public.connections ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own connections" ON public.connections FOR SELECT USING (auth.uid() = requester_id OR auth.uid() = receiver_id);
CREATE POLICY "Users can create connection requests" ON public.connections FOR INSERT WITH CHECK (auth.uid() = requester_id);
CREATE POLICY "Users can update connections they received" ON public.connections FOR UPDATE USING (auth.uid() = receiver_id);
CREATE POLICY "Users can delete own connections" ON public.connections FOR DELETE USING (auth.uid() = requester_id OR auth.uid() = receiver_id);

ALTER TABLE public.direct_messages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own DMs" ON public.direct_messages FOR SELECT USING (auth.uid() = sender_id OR auth.uid() = receiver_id);
CREATE POLICY "Users can send DMs" ON public.direct_messages FOR INSERT WITH CHECK (auth.uid() = sender_id);

ALTER TABLE public.documents ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all access to documents" ON public.documents FOR ALL USING (true) WITH CHECK (true);

-- ============================================================
-- 12. STORAGE BUCKETS
-- ============================================================
INSERT INTO storage.buckets (id, name, public) VALUES ('vault', 'vault', false);
INSERT INTO storage.buckets (id, name, public) VALUES ('chat-docs', 'chat-docs', true);

CREATE POLICY "Users can upload to vault" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'vault' AND auth.role() = 'authenticated');
CREATE POLICY "Users can view own vault files" ON storage.objects FOR SELECT USING (bucket_id = 'vault' AND auth.role() = 'authenticated');
CREATE POLICY "Users can delete own vault files" ON storage.objects FOR DELETE USING (bucket_id = 'vault' AND auth.role() = 'authenticated');
CREATE POLICY "Anyone can upload to chat-docs" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'chat-docs');
CREATE POLICY "Anyone can read chat-docs" ON storage.objects FOR SELECT USING (bucket_id = 'chat-docs');

-- ============================================================
-- ✅ DONE! Copy your Project URL + Anon Key from Settings → API
-- ============================================================
