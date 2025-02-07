-- ##########################################
-- Shopify Database Schema
-- Created: 2024
-- Description: Database schema for Shopify platform
-- ##########################################

-- ##########################################
-- Customer Related Tables
-- ##########################################

-- Customers table stores basic customer information
CREATE TABLE customers (
    id BIGSERIAL PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(50),
    accepts_marketing BOOLEAN DEFAULT FALSE,
    tax_exempt BOOLEAN DEFAULT FALSE,
    verified_email BOOLEAN DEFAULT FALSE,
    note TEXT,
    state VARCHAR(100),
    tags TEXT[],
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Customer addresses for shipping and billing
CREATE TABLE customer_addresses (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT REFERENCES customers(id),
    address1 VARCHAR(255),
    address2 VARCHAR(255),
    city VARCHAR(100),
    province VARCHAR(100),
    country VARCHAR(100),
    zip VARCHAR(20),
    phone VARCHAR(50),
    company VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    is_default_billing BOOLEAN DEFAULT FALSE,
    is_default_shipping BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ##########################################
-- Product Related Tables
-- ##########################################

-- Products table stores product information
CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    body_html TEXT,
    vendor VARCHAR(255),
    product_type VARCHAR(255),
    handle VARCHAR(255) UNIQUE,
    template_suffix VARCHAR(100),
    published_scope VARCHAR(50),
    tags TEXT[],
    status VARCHAR(50),
    published_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Product variants with specific attributes
CREATE TABLE product_variants (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT REFERENCES products(id),
    title VARCHAR(255),
    price DECIMAL(10,2),
    sku VARCHAR(255),
    position INTEGER,
    inventory_policy VARCHAR(50),
    compare_at_price DECIMAL(10,2),
    fulfillment_service VARCHAR(100),
    inventory_management VARCHAR(100),
    option1 VARCHAR(255),
    option2 VARCHAR(255),
    option3 VARCHAR(255),
    taxable BOOLEAN DEFAULT TRUE,
    barcode VARCHAR(100),
    grams INTEGER,
    weight DECIMAL(10,2),
    weight_unit VARCHAR(20),
    inventory_quantity INTEGER,
    requires_shipping BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Product images
CREATE TABLE product_images (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT REFERENCES products(id),
    position INTEGER,
    alt TEXT,
    width INTEGER,
    height INTEGER,
    src VARCHAR(2048),
    variant_ids BIGINT[],
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Product options (e.g., size, color)
CREATE TABLE product_options (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT REFERENCES products(id),
    name VARCHAR(255),
    position INTEGER,
    values TEXT[],
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ##########################################
-- Order Related Tables
-- ##########################################

-- Orders table for customer purchases
CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255),
    closed_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    number INTEGER,
    note TEXT,
    token VARCHAR(255),
    gateway VARCHAR(255),
    test BOOLEAN DEFAULT FALSE,
    total_price DECIMAL(10,2),
    subtotal_price DECIMAL(10,2),
    total_weight INTEGER,
    total_tax DECIMAL(10,2),
    taxes_included BOOLEAN DEFAULT FALSE,
    currency VARCHAR(10),
    financial_status VARCHAR(50),
    confirmed BOOLEAN DEFAULT FALSE,
    total_discounts DECIMAL(10,2),
    total_line_items_price DECIMAL(10,2),
    cart_token VARCHAR(255),
    buyer_accepts_marketing BOOLEAN DEFAULT FALSE,
    name VARCHAR(255),
    referring_site VARCHAR(2048),
    landing_site VARCHAR(2048),
    cancelled_at TIMESTAMP,
    cancel_reason VARCHAR(100),
    total_price_usd DECIMAL(10,2),
    checkout_token VARCHAR(255),
    reference VARCHAR(255),
    user_id BIGINT,
    location_id BIGINT,
    source_identifier VARCHAR(255),
    source_url VARCHAR(2048),
    processed_at TIMESTAMP,
    device_id BIGINT,
    phone VARCHAR(50),
    customer_locale VARCHAR(50),
    app_id BIGINT,
    browser_ip VARCHAR(100),
    landing_site_ref VARCHAR(255),
    order_number VARCHAR(100),
    processing_method VARCHAR(100),
    checkout_id BIGINT,
    source_name VARCHAR(100),
    fulfillment_status VARCHAR(50),
    tags TEXT[],
    contact_email VARCHAR(255),
    order_status_url VARCHAR(2048),
    customer_id BIGINT REFERENCES customers(id)
);

-- Order line items
CREATE TABLE order_line_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT REFERENCES orders(id),
    variant_id BIGINT REFERENCES product_variants(id),
    title VARCHAR(255),
    quantity INTEGER,
    price DECIMAL(10,2),
    grams INTEGER,
    sku VARCHAR(255),
    variant_title VARCHAR(255),
    vendor VARCHAR(255),
    fulfillment_service VARCHAR(100),
    product_id BIGINT REFERENCES products(id),
    requires_shipping BOOLEAN DEFAULT TRUE,
    taxable BOOLEAN DEFAULT TRUE,
    gift_card BOOLEAN DEFAULT FALSE,
    name VARCHAR(255),
    variant_inventory_management VARCHAR(100),
    properties JSONB,
    product_exists BOOLEAN DEFAULT TRUE,
    fulfillable_quantity INTEGER,
    total_discount DECIMAL(10,2),
    fulfillment_status VARCHAR(50),
    tax_lines JSONB,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Fulfillments tracking order delivery
CREATE TABLE fulfillments (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT REFERENCES orders(id),
    status VARCHAR(50),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    service VARCHAR(100),
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tracking_company VARCHAR(255),
    shipment_status VARCHAR(50),
    location_id BIGINT,
    tracking_number VARCHAR(255),
    tracking_numbers TEXT[],
    tracking_url VARCHAR(2048),
    tracking_urls TEXT[],
    receipt JSONB,
    name VARCHAR(255)
);

-- ##########################################
-- Transaction Related Tables
-- ##########################################

-- Transactions for order payments
CREATE TABLE transactions (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT REFERENCES orders(id),
    kind VARCHAR(50),
    gateway VARCHAR(255),
    status VARCHAR(50),
    message VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    test BOOLEAN DEFAULT FALSE,
    authorization VARCHAR(255),
    location_id BIGINT,
    user_id BIGINT,
    parent_id BIGINT,
    processed_at TIMESTAMP,
    device_id BIGINT,
    error_code VARCHAR(100),
    source_name VARCHAR(100),
    amount DECIMAL(10,2),
    currency VARCHAR(10),
    payment_details JSONB
);

-- ##########################################
-- Refund Related Tables
-- ##########################################

-- Refunds for orders
CREATE TABLE refunds (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT REFERENCES orders(id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    note TEXT,
    user_id BIGINT,
    processed_at TIMESTAMP,
    restock BOOLEAN DEFAULT FALSE,
    duties JSONB,
    total_duties_set JSONB,
    return_duties JSONB
);

-- Refund line items
CREATE TABLE refund_line_items (
    id BIGSERIAL PRIMARY KEY,
    refund_id BIGINT REFERENCES refunds(id),
    line_item_id BIGINT REFERENCES order_line_items(id),
    quantity INTEGER,
    location_id BIGINT,
    restock_type VARCHAR(50),
    subtotal DECIMAL(10,2),
    total_tax DECIMAL(10,2),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ##########################################
-- Indexes
-- ##########################################

CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_products_status ON products(status);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_created_at ON orders(created_at);
CREATE INDEX idx_transactions_order_id ON transactions(order_id);
CREATE INDEX idx_product_variants_product_id ON product_variants(product_id);
CREATE INDEX idx_fulfillments_order_id ON fulfillments(order_id);
CREATE INDEX idx_refunds_order_id ON refunds(order_id);

-- ##########################################
-- Triggers
-- ##########################################

-- Trigger function to update timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for all tables with updated_at
CREATE TRIGGER update_customer_updated_at
    BEFORE UPDATE ON customers
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Add similar triggers for other tables with updated_at columns
-- [Additional trigger definitions would go here]

-- ##########################################
-- Comments
-- ##########################################

COMMENT ON TABLE customers IS 'Stores customer information and preferences';
COMMENT ON TABLE orders IS 'Stores order information and status';
COMMENT ON TABLE products IS 'Stores product catalog information';
COMMENT ON TABLE transactions IS 'Stores payment transaction information';
COMMENT ON TABLE fulfillments IS 'Tracks order fulfillment and shipping status';
COMMENT ON TABLE refunds IS 'Manages order refunds and returns';

-- ##########################################
-- Customer Additional Tables
-- ##########################################

-- Customer saved searches
CREATE TABLE customer_saved_search (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT REFERENCES customers(id),
    name VARCHAR(255),
    query TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Customer payment methods
CREATE TABLE customer_payment_methods (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT REFERENCES customers(id),
    payment_type VARCHAR(50),
    provider VARCHAR(100),
    payment_details JSONB,
    default_method BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ##########################################
-- Additional Order Related Tables
-- ##########################################

-- Order adjustments
CREATE TABLE order_adjustments (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT REFERENCES orders(id),
    amount DECIMAL(10,2),
    kind VARCHAR(50),
    reason VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Order risks
CREATE TABLE order_risks (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT REFERENCES orders(id),
    checkout_id BIGINT,
    source VARCHAR(255),
    score DECIMAL(5,2),
    recommendation VARCHAR(50),
    merchant_message TEXT,
    display_message TEXT,
    cause_cancel BOOLEAN DEFAULT FALSE,
    message VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Draft orders
CREATE TABLE draft_orders (
    id BIGSERIAL PRIMARY KEY,
    note TEXT,
    email VARCHAR(255),
    status VARCHAR(50),
    currency VARCHAR(10),
    invoice_sent_at TIMESTAMP,
    invoice_url VARCHAR(2048),
    completed_at TIMESTAMP,
    tax_exempt BOOLEAN DEFAULT FALSE,
    total_price DECIMAL(10,2),
    subtotal_price DECIMAL(10,2),
    total_tax DECIMAL(10,2),
    customer_id BIGINT REFERENCES customers(id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Draft order line items
CREATE TABLE draft_order_line_items (
    id BIGSERIAL PRIMARY KEY,
    draft_order_id BIGINT REFERENCES draft_orders(id),
    variant_id BIGINT REFERENCES product_variants(id),
    product_id BIGINT REFERENCES products(id),
    title VARCHAR(255),
    variant_title VARCHAR(255),
    quantity INTEGER,
    price DECIMAL(10,2),
    grams INTEGER,
    requires_shipping BOOLEAN DEFAULT TRUE,
    tax_lines JSONB,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ##########################################
-- Additional Product Related Tables
-- ##########################################

-- Collections
CREATE TABLE collections (
    id BIGSERIAL PRIMARY KEY,
    handle VARCHAR(255) UNIQUE,
    title VARCHAR(255),
    description TEXT,
    published_scope VARCHAR(50),
    template_suffix VARCHAR(100),
    sort_order VARCHAR(50),
    published_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Collection products junction table
CREATE TABLE collection_products (
    collection_id BIGINT REFERENCES collections(id),
    product_id BIGINT REFERENCES products(id),
    position INTEGER,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (collection_id, product_id)
);

-- Smart collections (rule-based collections)
CREATE TABLE smart_collections (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255),
    handle VARCHAR(255) UNIQUE,
    body_html TEXT,
    published_at TIMESTAMP,
    rules JSONB,
    disjunctive BOOLEAN DEFAULT FALSE,
    sort_order VARCHAR(50),
    template_suffix VARCHAR(100),
    published_scope VARCHAR(50),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Custom collections
CREATE TABLE custom_collections (
    id BIGSERIAL PRIMARY KEY,
    handle VARCHAR(255) UNIQUE,
    title VARCHAR(255),
    body_html TEXT,
    published_at TIMESTAMP,
    sort_order VARCHAR(50),
    template_suffix VARCHAR(100),
    published_scope VARCHAR(50),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ##########################################
-- Additional Fulfillment Related Tables
-- ##########################################

-- Fulfillment events
CREATE TABLE fulfillment_events (
    id BIGSERIAL PRIMARY KEY,
    fulfillment_id BIGINT REFERENCES fulfillments(id),
    status VARCHAR(50),
    message VARCHAR(255),
    happened_at TIMESTAMP,
    city VARCHAR(100),
    province VARCHAR(100),
    country VARCHAR(100),
    zip VARCHAR(20),
    address1 VARCHAR(255),
    latitude DECIMAL(10,6),
    longitude DECIMAL(10,6),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Fulfillment line items
CREATE TABLE fulfillment_line_items (
    id BIGSERIAL PRIMARY KEY,
    fulfillment_id BIGINT REFERENCES fulfillments(id),
    line_item_id BIGINT REFERENCES order_line_items(id),
    quantity INTEGER,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Fulfillment services
CREATE TABLE fulfillment_services (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255),
    handle VARCHAR(255) UNIQUE,
    callback_url VARCHAR(2048),
    inventory_management BOOLEAN DEFAULT FALSE,
    tracking_support BOOLEAN DEFAULT FALSE,
    requires_shipping_method BOOLEAN DEFAULT FALSE,
    format VARCHAR(50),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Locations
CREATE TABLE locations (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255),
    address1 VARCHAR(255),
    address2 VARCHAR(255),
    city VARCHAR(100),
    province VARCHAR(100),
    country VARCHAR(100),
    zip VARCHAR(20),
    phone VARCHAR(50),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Inventory items
CREATE TABLE inventory_items (
    id BIGSERIAL PRIMARY KEY,
    sku VARCHAR(255),
    cost DECIMAL(10,2),
    tracked BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Inventory levels
CREATE TABLE inventory_levels (
    id BIGSERIAL PRIMARY KEY,
    location_id BIGINT REFERENCES locations(id),
    inventory_item_id BIGINT REFERENCES inventory_items(id),
    available INTEGER,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(location_id, inventory_item_id)
);

-- ##########################################
-- Payment/Transaction Related Tables
-- ##########################################

-- Payment terms
CREATE TABLE payment_terms (
    id BIGSERIAL PRIMARY KEY,
    payment_terms_name VARCHAR(255),
    payment_terms_type VARCHAR(50),
    due_in_days INTEGER,
    payment_schedules_count INTEGER,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Payment schedules
CREATE TABLE payment_schedules (
    id BIGSERIAL PRIMARY KEY,
    payment_terms_id BIGINT REFERENCES payment_terms(id),
    issued_at TIMESTAMP,
    due_at TIMESTAMP,
    completed_at TIMESTAMP,
    amount DECIMAL(10,2),
    currency VARCHAR(10),
    payment_terms_name VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Payment details
CREATE TABLE payment_details (
    id BIGSERIAL PRIMARY KEY,
    credit_card_bin VARCHAR(10),
    avs_result_code VARCHAR(10),
    cvv_result_code VARCHAR(10),
    credit_card_number VARCHAR(255),
    credit_card_company VARCHAR(50),
    credit_card_name VARCHAR(255),
    credit_card_wallet VARCHAR(50),
    credit_card_expiration_month INTEGER,
    credit_card_expiration_year INTEGER,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ##########################################
-- Shop Related Tables
-- ##########################################

-- Shop configuration
CREATE TABLE shop (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    domain VARCHAR(255),
    province VARCHAR(100),
    country VARCHAR(100),
    address1 VARCHAR(255),
    zip VARCHAR(20),
    city VARCHAR(100),
    source VARCHAR(255),
    phone VARCHAR(50),
    latitude DECIMAL(10,6),
    longitude DECIMAL(10,6),
    primary_locale VARCHAR(20),
    currency VARCHAR(10),
    timezone VARCHAR(100),
    iana_timezone VARCHAR(100),
    shop_owner VARCHAR(255),
    money_format VARCHAR(50),
    money_with_currency_format VARCHAR(50),
    weight_unit VARCHAR(20),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Shop alerts
CREATE TABLE shop_alerts (
    id BIGSERIAL PRIMARY KEY,
    shop_id BIGINT REFERENCES shop(id),
    message TEXT,
    severity VARCHAR(50),
    status VARCHAR(50),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Themes
CREATE TABLE themes (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255),
    role VARCHAR(50),
    theme_store_id BIGINT,
    previewable BOOLEAN DEFAULT TRUE,
    processing BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Assets (theme files)
CREATE TABLE assets (
    id BIGSERIAL PRIMARY KEY,
    theme_id BIGINT REFERENCES themes(id),
    key VARCHAR(255),
    value TEXT,
    attachment VARCHAR(2048),
    content_type VARCHAR(100),
    size INTEGER,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Metafields (custom metadata)
CREATE TABLE metafields (
    id BIGSERIAL PRIMARY KEY,
    namespace VARCHAR(255),
    key VARCHAR(255),
    value TEXT,
    value_type VARCHAR(50),
    description TEXT,
    owner_id BIGINT,
    owner_resource VARCHAR(50),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ##########################################
-- Marketing/Discount Related Tables
-- ##########################################

-- Price rules
CREATE TABLE price_rules (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255),
    target_type VARCHAR(50),
    target_selection VARCHAR(50),
    allocation_method VARCHAR(50),
    value_type VARCHAR(50),
    value DECIMAL(10,2),
    once_per_customer BOOLEAN DEFAULT FALSE,
    usage_limit INTEGER,
    customer_selection VARCHAR(50),
    prerequisite_subtotal_range DECIMAL(10,2),
    prerequisite_quantity_range INTEGER,
    prerequisite_shipping_price_range DECIMAL(10,2),
    starts_at TIMESTAMP,
    ends_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Discount codes
CREATE TABLE discount_codes (
    id BIGSERIAL PRIMARY KEY,
    price_rule_id BIGINT REFERENCES price_rules(id),
    code VARCHAR(255) UNIQUE,
    usage_count INTEGER DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Marketing events
CREATE TABLE marketing_events (
    id BIGSERIAL PRIMARY KEY,
    event_type VARCHAR(50),
    remote_id VARCHAR(255),
    started_at TIMESTAMP,
    ended_at TIMESTAMP,
    scheduled_to_end_at TIMESTAMP,
    budget DECIMAL(10,2),
    currency VARCHAR(10),
    manage_url VARCHAR(2048),
    preview_url VARCHAR(2048),
    utm_campaign VARCHAR(255),
    utm_source VARCHAR(255),
    utm_medium VARCHAR(255),
    budget_type VARCHAR(50),
    description TEXT,
    marketing_channel VARCHAR(50),
    paid BOOLEAN DEFAULT FALSE,
    referring_domain VARCHAR(255),
    breadcrumb_id VARCHAR(255),
    marketing_activity_id VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Abandoned checkouts
CREATE TABLE abandoned_checkouts (
    id BIGSERIAL PRIMARY KEY,
    token VARCHAR(255),
    cart_token VARCHAR(255),
    email VARCHAR(255),
    gateway VARCHAR(255),
    buyer_accepts_marketing BOOLEAN DEFAULT FALSE,
    currency VARCHAR(10),
    total_price DECIMAL(10,2),
    subtotal_price DECIMAL(10,2),
    total_tax DECIMAL(10,2),
    taxes_included BOOLEAN DEFAULT FALSE,
    total_discounts DECIMAL(10,2),
    source_name VARCHAR(100),
    source_identifier VARCHAR(255),
    source_url VARCHAR(2048),
    device_id VARCHAR(255),
    phone VARCHAR(50),
    customer_locale VARCHAR(50),
    recovered_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    customer_id BIGINT REFERENCES customers(id)
);

-- ##########################################
-- Additional Tables
-- ##########################################

-- Countries
CREATE TABLE countries (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255),
    code VARCHAR(2),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Provinces
CREATE TABLE provinces (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255),
    code VARCHAR(10),
    country_id BIGINT REFERENCES countries(id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Shipping zones
CREATE TABLE shipping_zones (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Shipping zone regions
CREATE TABLE shipping_zone_regions (
    id BIGSERIAL PRIMARY KEY,
    shipping_zone_id BIGINT REFERENCES shipping_zones(id),
    country_id BIGINT REFERENCES countries(id),
    province_id BIGINT REFERENCES provinces(id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Shipping rates
CREATE TABLE shipping_rates (
    id BIGSERIAL PRIMARY KEY,
    shipping_zone_id BIGINT REFERENCES shipping_zones(id),
    location_id BIGINT REFERENCES locations(id),
    rate DECIMAL(10,2),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ##########################################
-- Additional Triggers
-- ##########################################

-- Trigger function to update timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for all tables with updated_at
CREATE TRIGGER update_customer_updated_at
    BEFORE UPDATE ON customers
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Add similar triggers for other tables with updated_at columns
-- [Additional trigger definitions would go here]

-- ##########################################
-- Additional Comments
-- ##########################################

COMMENT ON TABLE payment_terms IS 'Stores payment terms information';
COMMENT ON TABLE payment_schedules IS 'Stores payment schedules information';
COMMENT ON TABLE payment_details IS 'Stores payment details information';
COMMENT ON TABLE shop IS 'Stores shop configuration information';
COMMENT ON TABLE shop_alerts IS 'Stores shop alerts information';
COMMENT ON TABLE themes IS 'Stores theme information';
COMMENT ON TABLE assets IS 'Stores theme assets information';
COMMENT ON TABLE metafields IS 'Stores custom metadata information';
COMMENT ON TABLE price_rules IS 'Stores price rules information';
COMMENT ON TABLE discount_codes IS 'Stores discount codes information';
COMMENT ON TABLE marketing_events IS 'Stores marketing events information';
COMMENT ON TABLE abandoned_checkouts IS 'Stores abandoned checkouts information';
COMMENT ON TABLE countries IS 'Stores country information';
COMMENT ON TABLE provinces IS 'Stores province information';
COMMENT ON TABLE shipping_zones IS 'Stores shipping zone information';
COMMENT ON TABLE shipping_zone_regions IS 'Stores shipping zone region information';
COMMENT ON TABLE shipping_rates IS 'Stores shipping rate information';

-- ##########################################
-- Additional Support Tables
-- ##########################################

-- Webhooks for external integrations
CREATE TABLE webhooks (
    id BIGSERIAL PRIMARY KEY,
    topic VARCHAR(255),
    address VARCHAR(2048),
    format VARCHAR(50),
    api_version VARCHAR(50),
    fields TEXT[],
    metafield_namespaces TEXT[],
    private_metafield_namespaces TEXT[],
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Events tracking system activities
CREATE TABLE events (
    id BIGSERIAL PRIMARY KEY,
    subject_id BIGINT,
    subject_type VARCHAR(255),
    verb VARCHAR(255),
    arguments JSONB,
    body TEXT,
    message TEXT,
    author VARCHAR(255),
    description TEXT,
    path VARCHAR(2048),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Comments on various resources
CREATE TABLE comments (
    id BIGSERIAL PRIMARY KEY,
    body TEXT,
    author VARCHAR(255),
    email VARCHAR(255),
    status VARCHAR(50),
    article_id BIGINT,
    blog_id BIGINT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Carrier services for shipping
CREATE TABLE carrier_services (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255),
    active BOOLEAN DEFAULT TRUE,
    service_discovery BOOLEAN DEFAULT TRUE,
    carrier_service_type VARCHAR(50),
    format VARCHAR(50),
    callback_url VARCHAR(2048),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Tax lines
CREATE TABLE tax_lines (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(255),
    price DECIMAL(10,2),
    rate DECIMAL(10,4),
    order_id BIGINT REFERENCES orders(id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Shipping lines
CREATE TABLE shipping_lines (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT REFERENCES orders(id),
    title VARCHAR(255),
    price DECIMAL(10,2),
    code VARCHAR(255),
    source VARCHAR(255),
    phone VARCHAR(50),
    requested_fulfillment_service_id VARCHAR(255),
    delivery_category VARCHAR(255),
    carrier_identifier VARCHAR(255),
    discounted_price DECIMAL(10,2),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ##########################################
-- Additional Indexes
-- ##########################################

CREATE INDEX idx_webhooks_topic ON webhooks(topic);
CREATE INDEX idx_events_subject_id ON events(subject_id);
CREATE INDEX idx_events_created_at ON events(created_at);
CREATE INDEX idx_comments_article_id ON comments(article_id);
CREATE INDEX idx_tax_lines_order_id ON tax_lines(order_id);
CREATE INDEX idx_shipping_lines_order_id ON shipping_lines(order_id);

-- ##########################################
-- Additional Comments
-- ##########################################

COMMENT ON TABLE webhooks IS 'Stores webhook configurations for external integrations';
COMMENT ON TABLE events IS 'Tracks system events and activities';
COMMENT ON TABLE comments IS 'Stores comments on articles and blogs';
COMMENT ON TABLE carrier_services IS 'Stores shipping carrier service configurations';
COMMENT ON TABLE tax_lines IS 'Stores tax calculations for orders';
COMMENT ON TABLE shipping_lines IS 'Stores shipping information for orders';

-- ##########################################
-- Additional Triggers
-- ##########################################

-- Create update timestamp triggers for new tables
CREATE TRIGGER update_webhooks_timestamp
    BEFORE UPDATE ON webhooks
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_comments_timestamp
    BEFORE UPDATE ON comments
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_carrier_services_timestamp
    BEFORE UPDATE ON carrier_services
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tax_lines_timestamp
    BEFORE UPDATE ON tax_lines
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_shipping_lines_timestamp
    BEFORE UPDATE ON shipping_lines
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column(); 