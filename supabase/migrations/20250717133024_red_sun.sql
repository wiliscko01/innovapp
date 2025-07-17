/*
  # Add AI Settings Fields to Chatbots Table

  1. Schema Updates
    - Add welcome_message field to ai_chatbots settings
    - Add daily_summary field to ai_chatbots settings  
    - Add subscription_plan field to ai_chatbots settings
    - Update existing chatbots with default values

  2. Security
    - Maintain existing RLS policies
    - No changes to authentication or permissions
*/

-- Update ai_chatbots table to ensure settings column has proper structure
DO $$
BEGIN
  -- Update existing chatbots to have proper settings structure
  UPDATE ai_chatbots 
  SET settings = COALESCE(settings, '{}'::jsonb) || jsonb_build_object(
    'welcome_message', COALESCE(settings->>'welcome_message', 'Bonjour! Comment puis-je vous aider aujourd''hui?'),
    'daily_summary', COALESCE((settings->>'daily_summary')::boolean, true),
    'subscription_plan', COALESCE(settings->>'subscription_plan', 'Basic'),
    'whatsapp_number', COALESCE(settings->>'whatsapp_number', ''),
    'language', COALESCE(settings->>'language', 'fr'),
    'personality', COALESCE(settings->>'personality', 'professional'),
    'features', COALESCE(settings->'features', '["whatsapp", "auto_response"]'::jsonb)
  )
  WHERE settings IS NULL OR 
        settings->>'welcome_message' IS NULL OR 
        settings->>'daily_summary' IS NULL OR 
        settings->>'subscription_plan' IS NULL;
END $$;

-- Create index for better performance on settings queries
CREATE INDEX IF NOT EXISTS idx_ai_chatbots_settings_subscription_plan 
ON ai_chatbots USING GIN ((settings->>'subscription_plan'));

-- Create index for WhatsApp number lookups
CREATE INDEX IF NOT EXISTS idx_ai_chatbots_settings_whatsapp 
ON ai_chatbots USING GIN ((settings->>'whatsapp_number'));

-- Add some sample data for testing if no chatbots exist
DO $$
DECLARE
    user_count INTEGER;
    admin_user_id UUID;
BEGIN
    -- Check if we have any users
    SELECT COUNT(*) INTO user_count FROM auth.users;
    
    IF user_count > 0 THEN
        -- Get the first admin user
        SELECT id INTO admin_user_id 
        FROM user_profiles 
        WHERE role = 'admin' 
        LIMIT 1;
        
        -- If we found an admin user and they don't have a chatbot, create one
        IF admin_user_id IS NOT NULL THEN
            INSERT INTO ai_chatbots (user_id, name, description, settings, is_active)
            SELECT 
                admin_user_id,
                'Assistant Commercial Inno''v Group',
                'Assistant IA pour le support client et les ventes',
                jsonb_build_object(
                    'welcome_message', 'Bonjour! Bienvenue chez Inno''v Group. Comment puis-je vous aider aujourd''hui?',
                    'daily_summary', true,
                    'subscription_plan', 'Pro',
                    'whatsapp_number', '+33612345678',
                    'language', 'fr',
                    'personality', 'professional',
                    'features', '["whatsapp", "auto_response", "multilingual", "analytics"]'::jsonb
                ),
                true
            WHERE NOT EXISTS (
                SELECT 1 FROM ai_chatbots WHERE user_id = admin_user_id
            );
        END IF;
    END IF;
END $$;