-- TODO: c_since ON UPDATE CURRENT_TIMESTAMP,

DROP TABLE order_line IF EXISTS;
CREATE TABLE order_line
(
  ol_w_id INTEGER NOT NULL,
  ol_d_id INTEGER NOT NULL,
  ol_o_id INTEGER NOT NULL,
  ol_number INTEGER NOT NULL,
  ol_i_id INTEGER NOT NULL,
  ol_delivery_d TIMESTAMP DEFAULT NULL,
  ol_amount DECIMAL(6,2) NOT NULL,
  ol_supply_w_id INTEGER NOT NULL,
  ol_quantity DECIMAL(2,0) NOT NULL,
  ol_dist_info VARCHAR(24) NOT NULL,
  PRIMARY KEY (ol_w_id,ol_d_id,ol_o_id,ol_number)
);;

DROP TABLE new_order IF EXISTS;
CREATE TABLE new_order
(
  no_w_id INTEGER NOT NULL,
  no_d_id INTEGER NOT NULL,
  no_o_id INTEGER NOT NULL,
  PRIMARY KEY (no_w_id,no_d_id,no_o_id)
);

DROP TABLE stock IF EXISTS;
CREATE TABLE stock
(
  s_w_id INTEGER NOT NULL,
  s_i_id INTEGER NOT NULL,
  s_quantity DECIMAL(4,0) NOT NULL,
  s_ytd DECIMAL(8,2) NOT NULL,
  s_order_cnt INTEGER NOT NULL,
  s_remote_cnt INTEGER NOT NULL,
  s_data VARCHAR(50) NOT NULL,
  s_dist_01 VARCHAR(24) NOT NULL,
  s_dist_02 VARCHAR(24) NOT NULL,
  s_dist_03 VARCHAR(24) NOT NULL,
  s_dist_04 VARCHAR(24) NOT NULL,
  s_dist_05 VARCHAR(24) NOT NULL,
  s_dist_06 VARCHAR(24) NOT NULL,
  s_dist_07 VARCHAR(24) NOT NULL,
  s_dist_08 VARCHAR(24) NOT NULL,
  s_dist_09 VARCHAR(24) NOT NULL,
  s_dist_10 VARCHAR(24) NOT NULL,
  PRIMARY KEY (s_w_id,s_i_id)
);

-- TODO: o_entry_d  ON UPDATE CURRENT_TIMESTAMP
DROP TABLE oorder IF EXISTS;
CREATE TABLE oorder
(
  o_w_id INTEGER NOT NULL,
  o_d_id INTEGER NOT NULL,
  o_id INTEGER NOT NULL,
  o_c_id INTEGER NOT NULL,
  o_carrier_id INTEGER DEFAULT NULL,
  o_ol_cnt DECIMAL(2,0) NOT NULL,
  o_all_local DECIMAL(1,0) NOT NULL,
  o_entry_d timestamp NOT NULL,
  PRIMARY KEY (o_w_id,o_d_id,o_id),
  UNIQUE (o_w_id,o_d_id,o_c_id,o_id)
);

-- TODO: h_date ON UPDATE CURRENT_TIMESTAMP
DROP TABLE history IF EXISTS;
CREATE TABLE history
(
  h_c_id INTEGER NOT NULL,
  h_c_d_id INTEGER NOT NULL,
  h_c_w_id INTEGER NOT NULL,
  h_d_id INTEGER NOT NULL,
  h_w_id INTEGER NOT NULL,
  h_date timestamp NOT NULL,
  h_amount DECIMAL(6,2) NOT NULL,
  h_data VARCHAR(24) NOT NULL
);

DROP TABLE customer IF EXISTS;
CREATE TABLE customer
(
  c_w_id INTEGER NOT NULL,
  c_d_id INTEGER NOT NULL,
  c_id INTEGER NOT NULL,
  c_discount DECIMAL(4,4) NOT NULL,
  c_credit VARCHAR(2) NOT NULL,
  c_last VARCHAR(16) NOT NULL,
  c_first VARCHAR(16) NOT NULL,
  c_credit_lim DECIMAL(12,2) NOT NULL,
  c_balance DECIMAL(12,2) NOT NULL,
  c_ytd_payment FLOAT NOT NULL,
  c_payment_cnt INTEGER NOT NULL,
  c_delivery_cnt INTEGER NOT NULL,
  c_street_1 VARCHAR(20) NOT NULL,
  c_street_2 VARCHAR(20) NOT NULL,
  c_city VARCHAR(20) NOT NULL,
  c_state VARCHAR(2) NOT NULL,
  c_zip VARCHAR(9) NOT NULL,
  c_phone VARCHAR(16) NOT NULL,
  c_since timestamp NOT NULL,
  c_middle VARCHAR(2) NOT NULL,
  c_data VARCHAR(500) NOT NULL,
  PRIMARY KEY (c_w_id,c_d_id,c_id)
);

DROP TABLE district IF EXISTS;
CREATE TABLE district
(
  d_w_id INTEGER NOT NULL,
  d_id INTEGER NOT NULL,
  d_ytd DECIMAL(12,2) NOT NULL,
  d_tax DECIMAL(4,4) NOT NULL,
  d_next_o_id INTEGER NOT NULL,
  d_name VARCHAR(10) NOT NULL,
  d_street_1 VARCHAR(20) NOT NULL,
  d_street_2 VARCHAR(20) NOT NULL,
  d_city VARCHAR(20) NOT NULL,
  d_state VARCHAR(2) NOT NULL,
  d_zip VARCHAR(9) NOT NULL,
  PRIMARY KEY (d_w_id,d_id)
);


DROP TABLE item IF EXISTS;
CREATE TABLE item
(
  i_id INTEGER NOT NULL,
  i_name VARCHAR(24) NOT NULL,
  i_price DECIMAL(5,2) NOT NULL,
  i_data VARCHAR(50) NOT NULL,
  i_im_id INTEGER NOT NULL,
  PRIMARY KEY (i_id)
);

DROP TABLE warehouse IF EXISTS;
CREATE TABLE warehouse
(
  w_id INTEGER NOT NULL,
  w_ytd DECIMAL(12,2) NOT NULL,
  w_tax DECIMAL(4,4) NOT NULL,
  w_name VARCHAR(10) NOT NULL,
  w_street_1 VARCHAR(20) NOT NULL,
  w_street_2 VARCHAR(20) NOT NULL,
  w_city VARCHAR(20) NOT NULL,
  w_state VARCHAR(2) NOT NULL,
  w_zip VARCHAR(9) NOT NULL,
  PRIMARY KEY (w_id)
);


--add constraINTEGERs and indexes
CREATE INDEX idx_customer_name ON customer (c_w_id,c_d_id,c_last,c_first);
CREATE INDEX idx_order ON oorder (o_w_id,o_d_id,o_c_id,o_id);
-- tpcc-mysql create two indexes for the foreign key constraINTEGERs, Is it really necessary?
-- CREATE INDEX FKEY_STOCK_2 ON STOCK (S_I_ID);
-- CREATE INDEX FKEY_ORDER_LINE_2 ON ORDER_LINE (OL_SUPPLY_W_ID,OL_I_ID);

--add 'ON DELETE CASCADE'  to clear table work correctly

ALTER TABLE district  ADD CONSTRAINT fkey_district_1 FOREIGN KEY(d_w_id) REFERENCES warehouse(w_id) ON DELETE CASCADE;
ALTER TABLE customer ADD CONSTRAINT fkey_customer_1 FOREIGN KEY(c_w_id,c_d_id) REFERENCES district(d_w_id,d_id)  ON DELETE CASCADE ;
ALTER TABLE history  ADD CONSTRAINT fkey_history_1 FOREIGN KEY(h_c_w_id,h_c_d_id,h_c_id) REFERENCES customer(c_w_id,c_d_id,c_id) ON DELETE CASCADE;
ALTER TABLE history  ADD CONSTRAINT fkey_history_2 FOREIGN KEY(h_w_id,h_d_id) REFERENCES district(d_w_id,d_id) ON DELETE CASCADE;
ALTER TABLE new_order ADD CONSTRAINT fkey_new_order_1 FOREIGN KEY(no_w_id,no_d_id,no_o_id) REFERENCES oorder(o_w_id,o_d_id,o_id) ON DELETE CASCADE;
ALTER TABLE oorder ADD CONSTRAINT fkey_order_1 FOREIGN KEY(o_w_id,o_d_id,o_c_id) REFERENCES customer(c_w_id,c_d_id,c_id) ON DELETE CASCADE;
ALTER TABLE order_line ADD CONSTRAINT fkey_order_line_1 FOREIGN KEY(ol_w_id,ol_d_id,ol_o_id) REFERENCES oorder(o_w_id,o_d_id,o_id) ON DELETE CASCADE;
ALTER TABLE order_line ADD CONSTRAINT fkey_order_line_2 FOREIGN KEY(ol_supply_w_id,ol_i_id) REFERENCES stock(s_w_id,s_i_id) ON DELETE CASCADE;
ALTER TABLE stock ADD CONSTRAINT fkey_stock_1 FOREIGN KEY(s_w_id) REFERENCES warehouse(w_id) ON DELETE CASCADE;
ALTER TABLE stock ADD CONSTRAINT fkey_stock_2 FOREIGN KEY(s_i_id) REFERENCES item(i_id) ON DELETE CASCADE;
