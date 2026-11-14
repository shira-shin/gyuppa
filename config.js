// 全国番付（Supabase）の接続先。
// anon / publishable キーは公開して構わない鍵です。書き込める内容は supabase/schema.sql のルール
// （名前の長さ、遊んだ時間に見合う得点、変更・削除の禁止、送信数の上限）で制限しています。
// ※ secret / service_role キーは、ここには絶対に書かないでください。
window.GYUPPA_CONFIG = {
  supabaseUrl: 'https://xcmaznimuqavuioqleds.supabase.co',
  supabaseAnonKey: 'sb_publishable_1Ryjvld7BTXF5uMmODi4MQ_ypIEkjuu'
};
