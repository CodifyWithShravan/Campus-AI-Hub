import { createClient } from '@supabase/supabase-js'

// Replace these with your actual Supabase details!
// You can find these in Supabase Dashboard -> Project Settings -> API
const supabaseUrl = 'https://ddzfqooziulntfxcrhsk.supabase.co'
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRkemZxb296aXVsbnRmeGNyaHNrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQzNzIwODYsImV4cCI6MjA5OTk0ODA4Nn0.UCV2dBsCYH7cimX-SUR11SI0FuD2yxnbyGmXYHXK-mQ'

export const supabase = createClient(supabaseUrl, supabaseKey)