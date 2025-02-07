-- System Parameters Tables
CREATE TABLE account_id (
    id BIGINT PRIMARY KEY,
    account_number VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE advertiser_level_specs_record (
    id BIGINT PRIMARY KEY,
    account_id BIGINT REFERENCES account_id(id),
    specs_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE campaign_fb_record (
    id BIGINT PRIMARY KEY,
    account_id BIGINT REFERENCES account_id(id),
    campaign_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE daily_budget (
    id BIGINT PRIMARY KEY,
    account_id BIGINT REFERENCES account_id(id),
    amount DECIMAL(10,2),
    currency VARCHAR(3),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE delivery_events (
    id BIGINT PRIMARY KEY,
    event_type VARCHAR(50),
    event_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE id_card_record (
    id BIGINT PRIMARY KEY,
    card_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE insights_analytics_ids (
    id BIGINT PRIMARY KEY,
    analytics_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE insights_record (
    id BIGINT PRIMARY KEY,
    record_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE operation_record (
    id BIGINT PRIMARY KEY,
    operation_type VARCHAR(50),
    operation_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE opt_out_info (
    id BIGINT PRIMARY KEY,
    opt_out_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_data_records_details_extra_info (
    id BIGINT PRIMARY KEY,
    extra_info_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_data_records (
    id BIGINT PRIMARY KEY,
    user_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- General Tables
CREATE TABLE creative (
    id BIGINT PRIMARY KEY,
    account_id BIGINT REFERENCES account_id(id),
    original_image_url TEXT,
    permalink_url TEXT,
    picture_url TEXT,
    source_url TEXT,
    status_type VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE supported_creative_in_objective (
    id BIGINT PRIMARY KEY,
    creative_id BIGINT REFERENCES creative(id),
    objective VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Content Parameters Tables
CREATE TABLE content_parameters (
    id BIGINT PRIMARY KEY,
    business_id BIGINT,
    campaign_info JSONB,
    custom_event_type VARCHAR(50),
    default_conversion_value DECIMAL(10,2),
    description TEXT,
    event_time TIMESTAMP,
    event_type VARCHAR(50),
    form_data JSONB,
    image_crops JSONB,
    image_hash VARCHAR(255),
    image_url TEXT,
    link TEXT,
    message TEXT,
    name VARCHAR(255),
    picture_string_base64 TEXT,
    platform VARCHAR(50),
    post_click_configuration_value JSONB,
    preview_shareable_link TEXT,
    source_type VARCHAR(50),
    targeting_description TEXT,
    template_url TEXT,
    video_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Ad Content Tables
CREATE TABLE ad_content (
    id BIGINT PRIMARY KEY,
    action_type VARCHAR(50),
    actor_id BIGINT,
    address TEXT,
    business_id BIGINT,
    business_rating_count INTEGER,
    business_rating_value DECIMAL(3,2),
    currency_code VARCHAR(3),
    delivery_info JSONB,
    delivery_time TIMESTAMP,
    dynamic_ad BOOLEAN,
    dynamic_rule JSONB,
    effective_status VARCHAR(50),
    effective_object_story_id VARCHAR(255),
    event_source_group_id BIGINT,
    event_time TIMESTAMP,
    event_type VARCHAR(50),
    field_data JSONB,
    funding_source VARCHAR(50),
    funding_source_details JSONB,
    is_autobid BOOLEAN,
    is_direct_deals_enabled BOOLEAN,
    is_dynamic_creative BOOLEAN,
    is_published BOOLEAN,
    message TEXT,
    name VARCHAR(255),
    object_story_id VARCHAR(255),
    object_story_spec JSONB,
    object_type VARCHAR(50),
    optimization_goal VARCHAR(50),
    place_page_id BIGINT,
    preview_shareable_link TEXT,
    reach INTEGER,
    rule JSONB,
    rule_id BIGINT,
    status VARCHAR(50),
    story_id VARCHAR(255),
    targeting JSONB,
    tracking_specs JSONB,
    user_tasks JSONB,
    user_id_assurance VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Strategies Tables
CREATE TABLE strategies (
    id BIGINT PRIMARY KEY,
    account_id BIGINT REFERENCES account_id(id),
    bid_strategy VARCHAR(50),
    business_object_id BIGINT,
    budget_remaining DECIMAL(10,2),
    buying_type VARCHAR(50),
    daily_budget DECIMAL(10,2),
    destination_type VARCHAR(50),
    effective_status VARCHAR(50),
    execution_options JSONB,
    frequency_control_specs JSONB,
    lifetime_budget DECIMAL(10,2),
    name VARCHAR(255),
    objective VARCHAR(50),
    pacing_type VARCHAR(50),
    promoted_object JSONB,
    recommendations JSONB,
    source VARCHAR(50),
    special_ad_category VARCHAR(50),
    special_ad_category_country VARCHAR(50),
    spend_cap DECIMAL(10,2),
    start_time TIMESTAMP,
    stop_time TIMESTAMP,
    targeting JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Ad Sets Tables
CREATE TABLE ad_sets (
    id BIGINT PRIMARY KEY,
    bid_amount DECIMAL(10,2),
    bid_info JSONB,
    campaign_id BIGINT,
    created_time TIMESTAMP,
    effective_status VARCHAR(50),
    lifetime_budget DECIMAL(10,2),
    name VARCHAR(255),
    optimization_goal VARCHAR(50),
    pacing_type VARCHAR(50),
    promoted_object JSONB,
    targeting JSONB,
    updated_time TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Ads Tables
CREATE TABLE ads (
    id BIGINT PRIMARY KEY,
    account_id BIGINT REFERENCES account_id(id),
    ad_review_feedback JSONB,
    adlabels JSONB,
    bid_amount DECIMAL(10,2),
    bid_info JSONB,
    bid_type VARCHAR(50),
    configured_status VARCHAR(50),
    conversion_domain TEXT,
    created_time TIMESTAMP,
    effective_status VARCHAR(50),
    last_updated_by_app_id BIGINT,
    name VARCHAR(255),
    recommendations JSONB,
    source_ad_id BIGINT,
    status VARCHAR(50),
    tracking_specs JSONB,
    updated_time TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Targeting Tables
CREATE TABLE targeting (
    id BIGINT PRIMARY KEY,
    age_max INTEGER,
    age_min INTEGER,
    custom_audiences JSONB,
    excluded_custom_audiences JSONB,
    geo_locations JSONB,
    interest_defaults_source VARCHAR(50),
    interests JSONB,
    targeting_optimization VARCHAR(50),
    user_adclusters JSONB,
    user_device JSONB,
    user_os JSONB,
    flexible_spec JSONB,
    custom_event JSONB,
    connections JSONB,
    contextual_bundling_spec JSONB,
    excluded_connections JSONB,
    excluded_publisher_categories JSONB,
    excluded_publisher_list_ids JSONB[],
    excluded_user_device JSONB,
    excluded_user_os JSONB,
    friends_of_connections JSONB,
    instagram_positions VARCHAR[],
    messenger_positions VARCHAR[],
    mobile_device_model JSONB,
    publisher_platforms VARCHAR[],
    reach_estimate_ready BOOLEAN,
    targeting_optimization_type VARCHAR(50),
    user_event JSONB,
    wireless_carrier JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add indexes for frequently accessed columns
CREATE INDEX idx_account_id ON account_id(id);
CREATE INDEX idx_ads_account_id ON ads(account_id);
CREATE INDEX idx_ad_sets_campaign_id ON ad_sets(campaign_id);
CREATE INDEX idx_creative_account_id ON creative(account_id);
CREATE INDEX idx_strategies_account_id ON strategies(account_id);

-- Add timestamps for all tables
ALTER TABLE account_id ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE advertiser_level_specs_record ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE campaign_fb_record ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE daily_budget ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE delivery_events ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE id_card_record ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE insights_analytics_ids ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE insights_record ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE operation_record ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE opt_out_info ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE user_data_records_details_extra_info ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE user_data_records ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE creative ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE supported_creative_in_objective ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE content_parameters ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE ad_content ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE strategies ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE ad_sets ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE ads ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE targeting ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Add triggers to automatically update updated_at timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for all tables
CREATE TRIGGER update_account_id_updated_at BEFORE UPDATE ON account_id FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_advertiser_level_specs_record_updated_at BEFORE UPDATE ON advertiser_level_specs_record FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_campaign_fb_record_updated_at BEFORE UPDATE ON campaign_fb_record FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_daily_budget_updated_at BEFORE UPDATE ON daily_budget FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_delivery_events_updated_at BEFORE UPDATE ON delivery_events FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_id_card_record_updated_at BEFORE UPDATE ON id_card_record FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_insights_analytics_ids_updated_at BEFORE UPDATE ON insights_analytics_ids FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_insights_record_updated_at BEFORE UPDATE ON insights_record FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_operation_record_updated_at BEFORE UPDATE ON operation_record FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_opt_out_info_updated_at BEFORE UPDATE ON opt_out_info FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_user_data_records_details_extra_info_updated_at BEFORE UPDATE ON user_data_records_details_extra_info FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_user_data_records_updated_at BEFORE UPDATE ON user_data_records FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_creative_updated_at BEFORE UPDATE ON creative FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_supported_creative_in_objective_updated_at BEFORE UPDATE ON supported_creative_in_objective FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_content_parameters_updated_at BEFORE UPDATE ON content_parameters FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_ad_content_updated_at BEFORE UPDATE ON ad_content FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_strategies_updated_at BEFORE UPDATE ON strategies FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_ad_sets_updated_at BEFORE UPDATE ON ad_sets FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_ads_updated_at BEFORE UPDATE ON ads FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_targeting_updated_at BEFORE UPDATE ON targeting FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
