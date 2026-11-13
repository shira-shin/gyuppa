// 全国番付（Supabase）の接続先。README の「全国番付を有効にする」を参照。
// 空のままなら、番付はこの端末の記録だけで動きます。
// anon key は公開して構わない鍵です（書き込める内容は supabase/schema.sql のルールで制限）。
window.GYUPPA_CONFIG = {
  supabaseUrl: '',      // 例: 'https://xxxxxxxx.supabase.co'
  supabaseAnonKey: ''   // 例: 'eyJhbGciOi...'
};
