abstract final class AppConfig {
  static const String supabaseUrl = 'https://pabshwauyntbqvttyftm.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
      '.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBhYnNod2F1eW50YnF2dHR5ZnRtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzcyOTE2MTMsImV4cCI6MjA5Mjg2NzYxM30'
      '.-pj0FjxcEIDIWscZa8WoyGeV3Ny7liM5muGLPD6QBnY';

  static const String appName = 'CAREVO';
  static const int dioConnectTimeoutMs = 15000;
  static const int dioReceiveTimeoutMs = 30000;
  static const int orderPageSize = 20;
  static const int maxPaymentProofSizeBytes = 5 * 1024 * 1024; // 5 MB
}
