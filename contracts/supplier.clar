;; Supplier contract for storing supplier information

;; Define the supplier data structure
(define-data-var supplier-id-nonce uint u0)

;; Map to store supplier information
(define-map suppliers
  uint
  {
    name: (string-ascii 256),
    location: (string-ascii 256),
    verification-status: bool,
    ipfs-hashes: (list 10 (string-ascii 64))
  }
)