-- Add an index to the ROW_KEY column for uniqueness
CREATE UNIQUE INDEX idx_row_key ON contracts(ROW_KEY);

-- Add an index to LGL_NM for vendor-based queries
CREATE INDEX idx_vendor_name ON contracts(LGL_NM);

-- Add an index to EFBGN_DT for date-based queries
CREATE INDEX idx_efbgn_dt ON contracts(EFBGN_DT);