const SUPABASE_URL = "https://dafzthchjvglzrxjsewi.supabase.co";
const SUPABASE_KEY = "sb_publishable_GfbL_TckwcfpDwl9D1Y_AA_CDfYdNRL"; // chave pública

const supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_KEY);

console.log("Conexão com o banco: ", supabaseClient)